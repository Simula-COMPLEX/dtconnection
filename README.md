# Prototyping Connection Between Digital Twin and Physical Twin for Autonomous Driving to Support Experimentation


## Description

If anybody want to continue on this work, I would suggest that you read the method chapter (chapter 3) in "UIO_masterthesis_soma.pdf". Further, to get the fundamental understanding of Digital Twins before starting, I would suggest that you read David Jones et al. 'Characterising the Digital Twin: A systematic literature review' and Tao Yue et al. 'Understanding Digital Twins for Cyber-Physical Systems: A Conceptual Model'

The thougth behind this project was to have the Digital Twin one step ahead of the Physical Twin, by adding this feature to the Digital Twin it is possible to find solutions in the digital world before we deploy actions to the physical world, in real time. Below is an image of the configuration that have been developed. The python code that is attatched in this rep got detailed comments, which also explains the flow of the configuration below.  

POST IMAGE HERE

The main tools that are used in this project is OpenModelica, Carla and Python. Most of the OpenModelica content which is used is developed by Massimo Ceraolo, so I would also suggest to check out his web-book which can be found here: https://omwebook.openmodelica.org/SMEHV. The 'dragF'-block which is designed by Massimo have been used to create the Drag Force Model, which adds the drag force equation to the Digital Twin. I would say that the Drag Force Model is a nice OpenModelica model that can be added to Digital Twins for vehicles, and this model can be found in the OpenModelica package DigitalTwinLibrary/CarlaTwin.mo in this rep. 

If the reader want to continue on this work, I would suggest to look at the overall configuration before diving into the Python code that is attatched, because it is many possible ways that you can connect OpenModelica and Carla to design a Digital Twin. It is also nice to have an idea of the goal for the configuration before you start, because it can be easy to get abit lost while working with several tools. One example configuration that I think can be interesting to further develop can be seen in the image below: 

POST IMAGE HERE




## Getting Started

### Dependencies

Carla 0.9.8

OpenModelica 1.16.1

Should not be a problem to use later releases

If you are going to use Python as the brigde between the tools, you should check out these two links: 
OM Python API: https://openmodelica.org/doc/OpenModelicaUsersGuide/latest/ompython.html
Carla Python API: https://carla.readthedocs.io/en/latest/build_windows/


### Installing

<b>DigitalTwinLibrary</b> - When you download this folder, you may want to save it togheter with the other OpenModelica libraries. The path should be ~\OpenModelica1.16.1-64bit\lib\omlibrary.

<b>Connected2API.py</b> gets it input data from a restfulAPI, which is accessed by a server that is located in China. You may need to apply a new method of feeding input data to the Digital Twin. In the configuration developed in Connected2API.py we only use the forward speed as input, so for prototyping you could create a numpy array that represents speed parameters as input data to the Digitla Twin, before you connect a Physical Twin. So, the script may need some changes if you want to run Connected2API.py. 

The changes that you need to apply if you <b>can not</b> connect to the restful API is: 


1. Either create a new restful API for the LGSVL-simulator etc, or create numpy arrays that represent the parameters that you want to feed the Digital Twin with and loop through them in the for loop. This is a nice method of prototyping the Digital Twin before we connect the system to a Physical Twin. If you want to connect the Digital Twin to a Physical Twin, you should fetch the sensor data from your robot/object, this data should be avaliable from a microchip/microprossessor on your robot. 
2. Replace the request.post("url") lines in Connected2API.py with the new method of feeding the Digital Twin with input data. The same logic could be used if you want to connect the Digital Twin to a Physical Twin. 

### Executing program

* Start the CARLA-simulator
* Make sure the server to the restfulAPI is turned on, if this is not possible, follow step 1-2 above. 
* Open your cmd and run Connected2API.py

## Authors
Øyvind Soma

oyvind.som@gmail.com

Please send me a mail if you have any questions or encounter any errors, I would be happy to help! 

## License

<a rel="license" href="http://creativecommons.org/licenses/by/4.0/"><img alt="Creative Commons License" style="border-width:0" src="https://i.creativecommons.org/l/by/4.0/88x31.png" /></a><br />This work is licensed under a <a rel="license" href="http://creativecommons.org/licenses/by/4.0/">Creative Commons Attribution 4.0 International License</a>.

## Acknowledgments

Massimo Ceraolo, Simplified Modelling of Electric and Hybrid Vehicles, url: https://omwebook.openmodelica.org/SMEHV

Alexander Koumis, Clarification regarding player measurements, url:https://github.com/carla-simulator/carla/issues/355#issuecomment-477472667

Adrian Pop, OpenModelica Examples, url: https://github.com/adrpo/OMExamples/tree/master/FMUResourceExample

CARLA documentation, url: https://carla.readthedocs.io/en/0.9.11/
