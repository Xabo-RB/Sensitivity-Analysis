# Sensitivity Analysis

![GitHub commit activity](https://img.shields.io/github/commit-activity/y/Xabo-RB/Sensitivity-Analysis?label=Commit%20activity&style=plastic)
![GitHub last commit](https://img.shields.io/github/last-commit/Xabo-RB/Sensitivity-Analysis?color=yellow&label=Last%20commit&style=plastic)

![Repo size](https://img.shields.io/github/repo-size/Xabo-RB/Sensitivity-Analysis?label=Repo%20size)

![Issues](https://img.shields.io/github/issues/Xabo-RB/Sensitivity-Analysis)
![Stars](https://img.shields.io/github/stars/Xabo-RB/Sensitivity-Analysis?style=social)
![Forks](https://img.shields.io/github/forks/Xabo-RB/Sensitivity-Analysis?style=social)


 Code to analyze the sensitivity of parameters with respect to time and within a numerical interval of interest. The method applies the complex perturbation differentiation.

## Workflow Jedi o Receta de sensibilidades (sólo para mentes ávidas de conocimiento)

1. En **Main** escoges si convertir o runear. 
    - Si conviertes simplemente convierte, no hay que hacer nada más.
    - Si Ejecutas pasamos al paso 2.

2. **Main** nos dirige a **WhatToDo**, que o convierte o runea. No hace más. Si convierte ahí termina la ejecución. Si runea pasamos al paso 3, el *estofado de sensibilidades*. 
Por qué este script? Pues se puede cambiar, principalmente para que el **Main** sea más simple, que sólo contenga lo imprescindible. Realmente son dos scripts que podían estar juntos. Pero es por limpieza.

3. Ya tenemos los ingredientes, y llegamos al script que gestiona todo. **SensitivityOrganizer**. Qué hace? Lee las opciones generales, archivo **options**.m. Lee las opciones particulares de cada modelo, presentes en la carpeta models con el nombre del **modelo+_options**. Y ejecuta el cálculo de sensibildiades para cada parámetro para posteriormente plotearlo y enviarlo a la carpeta results.

### PD: Cómo se ejecuta ahora? Qué hace el usuario?

El usuario modifica el main para decidir si convierte o runea sensibilidades. Para las sensibilidades tiene que modificar el archivo options.m de la carpeta principal. Y para cada modelo específic modifica las optiones correspondientes. Por qué así? Para que el usuario pueda guardar las options particulares de cada modelo y no sobreescribir el mismo fichero y perder las optiones de un modelo al siguiente.
