#!/usr/bin/env python
import glob
import os
import sys
import random
import time
import numpy as np
from OMPython import OMCSessionZMQ
from OMPython import ModelicaSystem
import matplotlib.pyplot as plt
import requests

omc = OMCSessionZMQ
model_path = \
    'C:/Program Files/OpenModelica1.16.1-64bit/lib/omlibrary/DigitalTwinLibrary/package.mo'

mod = ModelicaSystem(model_path, 'DigitalTwinLibrary.CarlaTwin.DragForceModel')
mod_historical = ModelicaSystem(model_path, 'DigitalTwinLibrary.CarlaTwin.SimpleCarModel')

table_path = \
    'C://Program Files//OpenModelica1.16.1-64bit//lib//' \
    'omlibrary//DigitalTwinLibrary//Resources//Data//' \
    'Tables//data_from_carla.txt'

requests.post("http://119.45.188.204:5000/LGSVL/LoadScene?scene=SanFrancisco&road_num=1")


try:
    sys.path.append(glob.glob('../carla/dist/carla-*%d.%d-%s.egg' % (
        sys.version_info.major,
        sys.version_info.minor,
        'win-amd64' if os.name == 'nt' else 'linux-x86_64'))[0])
except IndexError:
    pass


import carla



def plot(time_plot,om_plot,carla_plot, API_plot):
    plt.plot(time_plot, om_plot, label="OpenModelica")
    plt.plot(time_plot, carla_plot, label="Carla")
    plt.plot(time_plot, API_plot, label="restAPI")
    plt.xlabel('Time')
    plt.ylabel("Speed (m/s)")
    plt.title("OM and Carla DT, restAPI PT")
    plt.grid()
    plt.legend()
    plt.show()


def main():
    try:


        #Variables for the drag force equation
        rho = 0.001225        #Air density
        S = 2.22              #Vehicle cross area
        Cx = 0.23             #Drag coefficient

        mod.setParameters("dragForce.rho={}".format(rho))
        mod.setParameters("dragForce.S={}".format(S))
        mod.setParameters("dragForce.Cx={}".format(Cx))

        #Saving all actors in one list
        actor_list = []

        #Client
        client = carla.Client("localhost", 2000)
        client.set_timeout(10.0)

        #Find a world
        world = client.get_world()
        blueprint_library = world.get_blueprint_library()

        #Pick car
        bp = blueprint_library.filter("model3")[0]
        m = 1600  # Weigth of a tesla model 3
        mod.setParameters("mass.m={}".format(m))

        #Spawning the car
        spawn_point = world.get_map().get_spawn_points()[1]
        vehicle = world.spawn_actor(bp, spawn_point)

        physics_control = vehicle.get_physics_control()
        physics_control.mass = m
        physics_control.drag_coefficient = Cx


        #Appending to a actor list
        actor_list.append(vehicle)  # Vehicle in position 0

        repeat = 10
        f = open(table_path, 'w')
        f.write('#1' + '\n' + 'float table1('+str(repeat)+',2)' + '\n')

        time_plot = []
        om_plot = []
        carla_plot = []
        API_plot= []

        Light = True
        Medium = False
        Heavy = False

        if Light == True:
            requests.post("http://119.45.188.204:5000/LGSVL/Control/Weather/Rain?rain_level=Light")
            requests.post("http://119.45.188.204:5000/LGSVL/Control/Weather/Fog?fog_level=Light")
            requests.post("http://119.45.188.204:5000/LGSVL/Control/Weather/Wetness?wetness_level=Light")
            weather = carla.WeatherParameters.SoftRainSunset
            world.set_weather(weather)
            fc = 0.01 # Rolling resistance

        if Medium == True:
            requests.post("http://119.45.188.204:5000/LGSVL/Control/Weather/Rain?rain_level=Moderate")
            requests.post("http://119.45.188.204:5000/LGSVL/Control/Weather/Fog?fog_level=Moderate")
            requests.post("http://119.45.188.204:5000/LGSVL/Control/Weather/Wetness?wetness_level=Moderate")
            weather = carla.WeatherParameters.MidRainSunset
            world.set_weather(weather)
            fc = 0.02  # Rolling resistance

        if Heavy == True:
            requests.post("http://119.45.188.204:5000/LGSVL/Control/Weather/Rain?rain_level=Heavy")
            requests.post("http://119.45.188.204:5000/LGSVL/Control/Weather/Fog?fog_level=Heavy")
            requests.post("http://119.45.188.204:5000/LGSVL/Control/Weather/Wetness?wetness_level=Heavy")
            weather = carla.WeatherParameters.HardRainSunset
            world.set_weather(weather)
            fc = 0.03  # Rolling resistance

        mod.setParameters("dragForce.fc={}".format(fc))
        increment = 0

        for _ in range(repeat):

            start = time.time()

            #World tick so we can GET the transform of the vehicle in Carla
            world.tick()
            world.wait_for_tick()

            #The next three lines is dependent on the API that represent your Physicla Twin.
            requests.post("http://119.45.188.204:5000/LGSVL/Run?t=2")  # you can change the value of t
            speed_req = requests.post("http://119.45.188.204:5000/LGSVL/Status/EGOVehicle/Speed")
            speed = speed_req.json()

            #The next lines got implemented because there were not implemented any steering for the DT
            #If we implement steering, the speed dont need to be increment.
            #The speed increment made sure that we could analyze the simulation for a couple of world tick in carla,
            #before the vehicle crashed.
            speed = speed*increment
            increment+=0.2

            #Rotation matrix around the yaw axis in Carla
            #As seen, we are GETting the transform from Carla
            yaw = np.radians(vehicle.get_transform().rotation.yaw)
            rotation_m = np.array([
                [np.cos(yaw), -np.sin(yaw),0],
                [np.sin(yaw),np.cos(yaw),0],
                [0,0,1]
            ])

            #Printing some speed parameters to see what's going on
            print(str(speed))
            #Appending for ploting
            API_plot.append(speed)
            #And saving the histroical data in our text file
            f.write(' ' + str(_) + '  ' + (str(round(speed,3))) + '\n')

            #3x1 Vector that are going to be multiplied with the 3x3 matrix
            new_speed = np.array([speed, 0, 0])

            #Matrix mul
            input_vel = rotation_m @ new_speed
            #Converting the result to a Carla vector, so carla can read the data
            vector_vel = carla.Vector3D(input_vel[0], input_vel[1], input_vel[2])
            #Set the new velocity in Carla
            vehicle.set_velocity(vector_vel)

            #We need to add two world ticks, for Carla to be updated with the new speed
            #REF Carla documentation
            world.tick()
            world.wait_for_tick()
            world.tick()
            world.wait_for_tick()

            #When the new speed is set, we want to fetch the accelration and the speed of the Carla vehicle
            acceleration_3d = vehicle.get_acceleration()

            #Applying pytagoras to go from 3D to 1D, for both the a and the v
            a3d_to_a = np.array([acceleration_3d.x, acceleration_3d.y, acceleration_3d.z])
            a_temp = np.sqrt(np.square(a3d_to_a[0]) + np.square(a3d_to_a[1]) + np.square(a3d_to_a[2]))
            a = round(a_temp,3)

            velocity_3d = vehicle.get_velocity()
            velocity = np.array([velocity_3d.x, velocity_3d.y, velocity_3d.z])
            v_temp = np.sqrt(np.square(velocity[0]) + np.square(velocity[1]) + np.square(velocity[2]))
            v = round(v_temp,3)

            #When we got the information we need from Carla, we want to SET that information to OpenModelica
            mod.setParameters("start_vel.k={}".format(v))
            mod.setParameters("start_acc.k={}".format(a))

            #We then need to get the transform again, in case the vehicle is turning, before we return the measured-
            #parameters from carla.
            #In this scenario the vehicle is driving straight so the transform will probably be the same,
            #So the next lines may be not useful for this script
            #But if we implement steering, the rotation may change over the added world ticks
            #So it is nice to keep in mind, if anybody wanna add more feature to this script
            #so that is why we are finding a new rotation matrix here
            yaw = np.radians(vehicle.get_transform().rotation.yaw)
            rotation_m = np.array([
                [np.cos(yaw), -np.sin(yaw),0],
                [np.sin(yaw),np.cos(yaw),0],
                [0,0,1]
            ])

            #Stop the time, to make sure the simulation in OpenModelica is the same length as in Carla
            stop = time.time()
            duration = stop-start
            #Set the simulation options with the measured time
            mod.setSimulationOptions("stopTime="+str(duration))
            #And then we simulate the model
            mod.simulate()

            #Get the sensor data from OM, to get the predicted/measured speed from Drag Force Model
            vel_sensor = mod.getSolutions("speedSensor.v")[0]
            OM_vel = vel_sensor[len(vel_sensor)-1]

            #Matrix mul to SET the new speed back to the Carla environment
            OM_vel_3d = np.array([OM_vel,0,0])
            carla_input_vel = rotation_m@OM_vel_3d
            carla_vector_vel = carla.Vector3D(carla_input_vel[0], carla_input_vel[1], carla_input_vel[2])
            vehicle.set_velocity(carla_vector_vel)

            #Make sure the speed in Carla is updated!
            world.tick()
            world.wait_for_tick()
            world.tick()
            world.wait_for_tick()


            #To make this useful, we should add some more features here...
            #Till now, this script can predict how the speed will change if the road is more wet,
            #And that prediction should be used in a useful way.

            #The prediction is just returned to Carla now,
            #and the Physical Twin will change the speed on the next world tick in the next iteration
            #But before the next iteration start, we got Carla one step ahead of the Physical Twin,
            #and i believe we can use that for something nice.

            #So my suggestion is to think of ways to make that prediction useful, and also implement some methods of
            #steering the vehicle. Carla got a integrated PID controller which can be used.



            om_plot.append(OM_vel)
            carla_plot.append(v)
            time_plot.append(_)

        f.close()

        #The second model is being simulated here to re-simulate the scenario with the Simple Car model
        mod_historical.setSimulationOptions("stopTime="+str(repeat))
        mod_historical.simulate()
        print("Simulated!")


        #Some plotting
        plt.plot(time_plot,om_plot, label="OpenModelica")
        plt.xlabel('Time')
        plt.ylabel("Speed (m/s)")
        plt.title("Re-simulation with OM")
        plt.grid()
        plt.legend()
        plt.show()

        plot(time_plot, om_plot, carla_plot, API_plot)

        time.sleep(5)

    finally:
        for actor in actor_list:
            actor.destroy()
        print("Finished!")


if __name__ == '__main__':
    main()