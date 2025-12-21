---
title: Introducción
taxonomy:
    category: docs
---

# Objetivos: Tuberías CI/CD en el UnderCloud

Los ejecicios que se proponen van, paso a paso, construyendo una tubería de integracón y despliegue continuo (CI/CD) como ilustra la imagen, estableciendo una metodología de trabajo para este tipo de proyectos de UnderCloud.
+ **CD: API - Proyectos de Infraestructura**, integración de la API MaaS (Metal as a Service) almacenada en repositorio GIT. Cambios en Git disparan Workflows de despliegue continuo (CD).
+ **CI: Lógica - Proyectos de Librerías**, librería o colecciones de librerías, con sus pruebas unitarias. A estos proyectos se le asocia Workflows de integración continua (CI) con regresivos que garantizan la continuidad de la funcionalidad.

![Tuberías CI/CD](image://auto/gitops_ci_cd.jpg)

# Estructura de los Ejercicios

## Ansible
Revisar los estándares de programación Ansible que está promoviendo RedHat en sus manuales a través de una demostración práctica.
- **Estándares de Programación:** se toma como referencia [Linux System Roles](https://linux-system-roles.github.io/?target=_blank), la colección que emplea RedHat para todos sus despliegues. Se localizan sus políticas de buenas prácticas.
- **Estándares de Ejecución:** encapsular lógica y sus dependencias en contenedor (Ansible Execution Environment).
- **Estándares de Desarrollo:** flujos GitOps... tuberías CI/CD en Ansible.

## GitOps_CD: Continuous Delivery

La sección GitOps_CD se basa en el proyeto de infraestructura visto en la sección Ansible y le agrega workflow de entrega continua, para ver como opera esto en la práctica. Se emplea GitHub Actions, aunque existen herramientas específicas para estas tareas.

## GitOps_CI
La programación de librería ansible sigue la filosofgía TDD (Test Driven Development). Esta sección elabora una pequeña librería, centrando la atención en todos los sistemas de pruebas que permiten aplicar filosofía TDD. 

Tal como se aprecia en esta librería que se toma como referencia, la carpeta tests de los roles de Ansible tiene una prueba unitaria para cada configuración que debe poder aplicar el módulo... las pruebas unitaias que van a integrarse en regresivos. 
+ [Linux System Roles](https://github.com/linux-system-roles/network?target=_blank)
![Pruebas Ansible](image://auto/molecule.jpg)

**MOLECULE**                        | **TOX** 
------------------------------------|---------------------------------------
<div class="grav-youtube"><iframe src="https://www.youtube.com/embed/hglpWHMyFHA?si=xp7mS_ZOYxIyDror" frameborder="0" allowfullscreen=""></iframe></div> | <div class="grav-youtube"><iframe src="https://www.youtube.com/embed/XUMqKoQEls8?si=WeYPN-9cJ9XxcPcS" frameborder="0" allowfullscreen=""></iframe></div> 

## PXE
El proceso PXE es muy importante en la gestión de Infraestructua como Código. Esta sección arma uno desde cero, dando la oportunidad de integrar todo lo visto anteriormente en un sistema de trabajo:
- **Proyectos de librería Ansible:** se emplea aun servidor DHCP como ejemplo que permite ver todos los aspectos del desarrollo de lógica ansible.
- **Proyectos de Infraestructura** el servidor PXE sirve para ver cómo se trabaja con proyectos de integración. 
- **Bootloader iPXE** está ampliamente extendido en toda la industria este bootloadar para instalaciones desatendidas, debido a su alta compatibilidad con el hardware, la posibilidad de comunidaciones encriptadas en los plataformados y consola de recuperación ante errores. Se construye iPXE desde cero, y se integra en este servidor.
- **Instaladores de Sistema Operativo** se revisan las distintas opciones: kickstart, cloud-init, CloneZilla Server, Ignition Files.

![Instalación Desatendida](image://intro/pxe.jpg)  
 
# TDD = Test Driven Development 
Los principios de desarrollo TDD que sigue este ejemplo se ilustran en la imagen, y que se ilustran a través de los siguiente autores:
+ [Linux System Network Roles](https://github.com/linux-system-roles/?target=_blank)
+ [Open Networking Foundation Roles](https://github.com/OpenNetworkingFoundation?target=_blank)
+ [Robert de Bock Roles](https://robertdebock.nl/?target=_blank)
![Pruebas Integración](image://auto/tdd.png)
