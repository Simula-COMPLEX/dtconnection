# Prototyping Connection Between Digital Twin and Physical Twin for Autonomous Driving to Support Experimentation


## Description

If anybody want to continue on this work, I would suggest that you read the method chapter (chapter 3) in "UIO_masterthesis_soma.pdf". Further, to get the fundamental understanding of Digital Twins before starting, I would suggest that you red David Jones et al. 'Characterising the Digital Twin: A systematic literature review' and Tao Yue et al. 'Understanding Digital Twins for Cyber-Physical Systems: A Conceptual Model'

The thougth behind this project was to have the Digital Twin one step ahead of the Physical Twin, by adding this feature to the Digital Twin it is possible to find solutions in the digital world before we deploy actions to the physical world, in real time. Below is an image of the configuration that have been developed. The python code that is attatched in this rep got detailed comments, which also explains the flow of the configuration below.  

POST IMAGE HERE

The main tools that are used in this project is OpenModelica, Carla and Python. Most of the OpenModelica content which is used is developed by Massimo Cereaolo, so I would also suggest to check out his web-book which can be found here: https://omwebook.openmodelica.org/SMEHV. The 'dragF'-block which is designed by Massimo have been used to create the Drag Force Model, which adds the Drag Force Equation to the digital world. I would say that the Drag Force Model is a nice OpenModelica model that can be added to Digital Twins for vehicles, and this model can be found in the OpenModelica package DigitalTwinLibrary/CarlaTwin.mo in this rep. 

If the reader want to continue on this work, I would suggest to look at the overall configuration before diving into the Python code that is attatched, because it is many possible ways that you can connect OpenModelica and Carla to design a Digital Twin. One example configuration can be seen in the image below: 

POST IMAGE HERE




## Getting Started

### Dependencies

* Describe any prerequisites, libraries, OS version, etc., needed before installing program.
* ex. Windows 10

### Installing

* How/where to download your program
* Any modifications needed to be made to files/folders

### Executing program

* How to run the program
* Step-by-step bullets
```
code blocks for commands
```

## Help

Any advise for common problems or issues.
```
command to run if program contains helper info
```

## Authors
Øyvind Soma

oyvind.som@gmail.com

Please send me a mail if you have any questions, I would be happy to help! 

## License

<a rel="license" href="http://creativecommons.org/licenses/by/4.0/"><img alt="Creative Commons License" style="border-width:0" src="https://i.creativecommons.org/l/by/4.0/88x31.png" /></a><br />This work is licensed under a <a rel="license" href="http://creativecommons.org/licenses/by/4.0/">Creative Commons Attribution 4.0 International License</a>.

## Acknowledgments

Massimo Ceraolo, Simplified Modelling of Electric and Hybrid Vehicles, url: https://omwebook.openmodelica.org/SMEHV

Alexander Koumis, Clarification regarding player measurements, url:https://github.com/carla-simulator/carla/issues/355#issuecomment-477472667

Adrian Pop, OpenModelica Examples, url: https://github.com/adrpo/OMExamples/tree/master/FMUResourceExample

CARLA documentation, url: https://carla.readthedocs.io/en/0.9.11/
