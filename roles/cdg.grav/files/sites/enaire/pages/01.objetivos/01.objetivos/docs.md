---
title: Objetivos
taxonomy:
    category: docs
---

# Introducción
Enaire tiene entornos de trabajo altamente regulados, muchas veces los técnicos enfrentan situaciones de alto estrés al tener que resolver problemas en producción que no han podido experimentar antes en entornos de maqueta y que en ocasiones no comprenden bien... se limitan a seguir instrucciones de manera ciega. 

**Aquí se propone entornos de trabajo de "usar y tirar" donde aprender los fundamentos de Linux** de manera sencilla y práctica, **además de emular procedimientos de todo tipo** en un entorno donde todo puede experimentarse y todo puede romperse... sin perder de vista una posible evolución futura para incorporar otras tecnologías Linux, como clústers OpenShift. Esta muestra piloto se centra en procedimientos del mueble iFocus.

## Disposición de Muebles iFocus

+ **Los muebles iFocus son controlados desde ordenadores XR12 con aplicaciones de tráfico aéreo encapsuladas en Máquina Virtual** (dos para planificador, dos para ejecutivo). En otras palabras, el ordenador iFocus son cuatro máquinas anfitrionas XR12 especializadas en gestionar instancias de máquinas virtuales que encapsulan cada aplicación de tráfico aéreo, con todas sus dependencias (sistema operativo y librerías).

+ **Consola iFocus y ordenador están en distintas salas**, conectadas a través de cables de fibra óptica. Detrás de cada mueble iFOCUS, hay un armario con agregadores que multiplexan las señales de las distintas conexiones que viene del mueble sobre una misma fibra óptica. En la sala de cómputo, hay un armario por mueble iFOCUS que tiene sus cuatro XR12 en la parte inferior y los disgregadores en la parte superior que demultiplexan esas señales de la fibra óptica para llevarlas a los ordenadores XR12.

![Instalacion iFocus](image://intro/ifocus_mueble.jpg)

## Despliegue de Muebles iFocus

Tal como muestra la figura, Enaire libera versiones tanto de aplicativo como de máquina virtual, los centros de control son responsables de:

+  **Realizar un proceso de puesta en marcha**, es decir, inyectarles aplicación a las máquinas virtuales, y a partir de ahí, propagarlas por todos los muebles que gestione el centro de control. 

+ **Conocer diferencias entre los tres tipos de chasis virtual** sobre los que inyectar la aplicación, cada uno con una versión de RedHat Enterprise Linux (RHEL) diferente:
   - RHEL6 para POS
   - RHEL7 para OUCS 
   - RHEL8 para CWP. 
   - RHEL 8.6 para el anfitrión (XR12) 
   
+ ** Control de Versiones de Instancias de máquina virtual** que están ejecutándose en cada mueble iFocus del centro.

![Proceso de Despliegue de los Muebles iFocus](image://intro/ifocus_despliegue.jpg)
 
##	Tareas de Mantenimiento de Muebles iFocus
### Mantanimientos del Hardware
Consiste en automatizar los diagnósticos de los periféricos de mueble para hacer verificaciones periódicas de su estado e ir clasificando y guardando los distintos errores que vayan surgiendo, o sea, ir creando una base de datos errores del mueble iFOCUS clasificada de tal forma que sea fácil encontrar cómo resolver cada caso. Para ellos basarse en:

+ **Protocolos diagnóstico preexistentes y bien probados**, ya sean propios de Indra, ya sean adaptados a partir de Ubuntu, IBM o RedHat. Cada protocolo establece una cadena de eventos y puntos de sondeo, los casos de error puede clasificarse por punto de sondeo y las medidas de corrección para cada error que vaya surgiendo, estableciendo un catálogo de modos de actuación. Ejemplos de Protocolos de diagnóstico:
  - [Ubuntu protocolo Touchpad](https://wiki.ubuntu.com/DebuggingTouchpadDetection?target=_blank)
  - [IBM protocolo Chrony](https://www.ibm.com/support/pages/how-troublsehoot-chrony-issues?target=_blank)
  
+ **Herramientas de Análisis RedHat:** el fabricante tiene una formación donde se clasifican procedimientos de diagnóstico para cada tipo de problema ([EX342 - Linux Diagnostics and Troubleshooting](https://www.redhat.com/es/services/certification/rhcs-red-hat-enterprise-linux-diagnostics-and-troubleshooting?target=_blank)). Cualquier protocolo puede incorporar estos procedimientos como parte de sus diagnósticos, al estar bien probados, al punto de existir formaciones y certificaciones en ellos.

### Mantanimientos del Software

+ **Mantener un repositorio de máquinas virtuales listas para ser instanciadas en cualquier mueble iFocus** (tanto TMA como Ruta). Para esto resulta clave practicar los procedimientos de regeneración instancias.

+ **Mantener bajo control los parámetros de instancia en cada posición de los distintos mueble iFOCUS**, lo que permite la instanciación automatizada de esas máquinas virtuales de referencia en cada mueble del centro de control (las instancias no guardan datos, sino que se sincronizan con servidores externos). Clave es la gestión de versiones, tanto el repositorio de máquinas virtuales de referencia, como parámetros instancia en cada mueble.

![Distribución de Instancias en los Muebles iFocus](image://intro/ifocus_instancias.jpg)
 
# Bibliografía
#### Documentación Linux
+ [Entorno Ejecución RedHat](https://docs.redhat.com/es-es/documentation/red_hat_enterprise_linux/8/pdf/configuring_basic_system_settings/Red_Hat_Enterprise_Linux-8-Configuring_basic_system_settings-es-ES.pdf?target=_blank)
+ [Subsistema NetworkManager](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/8/pdf/configuring_and_managing_networking/red_hat_enterprise_linux-8-configuring_and_managing_networking-en-us.pdf?target=_blank)
+ [Subsistema Virtualización](https://docs.redhat.com/es-es/documentation/red_hat_enterprise_linux/8/pdf/configuring_and_managing_virtualization/Red_Hat_Enterprise_Linux-8-Configuring_and_managing_virtualization-es-ES.pdf?target=_blank)
+ [Seguridad en Linux](https://docs.redhat.com/es-es/documentation/red_hat_enterprise_linux/8/pdf/security_hardening/Red_Hat_Enterprise_Linux-8-Security_hardening-es-ES.pdf?target=_blank)
+ [Rendimiento en Linux](https://www.brendangregg.com/linuxperf.html?target=_blank)
+ [Resumen de Comandos Linux](https://phoenixnap.com/kb/linux-commands-cheat-sheet?target=_blank)
+ [Automatización RedHat, paradigma GitOps](https://www.redhat.com/en/blog/ansible-and-openshift-connecting-for-success?target=_blank)