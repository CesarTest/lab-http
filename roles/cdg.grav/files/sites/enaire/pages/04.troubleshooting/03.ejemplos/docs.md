---
title: Ejemplos
taxonomy:
    category: docs
---

# Elaborando Protocolos de  Diagnóstico
## Maletín Herramientas de Análisis: Arquitectura von Neumann
![Arquitectura PC](image://intro/neumann.png)
El troubleshooting comienza con el diagnóstico del problema, que consiste en definir la sintomatología y a partir de ella detectar los subsistemas afectados. De estos subsistemas afectados, se van a recabar las evidencias (a lo largo de toda su anatomía) que permitan acometer la resolución del problema. En conclusión, para diagnosticar cualquier problema es necesario:

+ **¿Qué? - Conocer Herramientas de Diagnóstico a disposición:**
   -	<u> Clasificación de Herramientas:</u> como si de un maletín se tratase, se ordenan según qué parte de la arquitectura von Neumann analizan:
	     + *Hardware (Entrada/Salida) - [Southbridge de las placas madre](https://es.wikipedia.org/wiki/Puente_sur?target=_blank):* abstracciones detrás de los descriptores de fichero que presenta el kernel a las aplicaciones. Las aplicaciones leen y escriben sobre estos descriptores de fichero a través de la API de llamadas a sistemas que presenta el kernel para abstraer las propiedades del hardware y cómo se gestiona. El [South Bridge](https://es.wikipedia.org/wiki/Puente_sur?target=_blank) de la placa madre incorpora una [DMA (Direct Memory Access)](https://es.wikipedia.org/wiki/Acceso_directo_a_memoria?target=_blank) que vuelca los datos de cada dispositivo hardware en una sección de memoria RAM asignada al dispositivo. Los programas leen de esas secciones de memoria como si de un dato más se tratase. En máquinas virtuales, jugando con estas posiciones de memoria, se puentea el dispositivo hardware de la máquina física anfitriona a la máquina virtual ([IOMMU (Input/Output Memory Management Unit)](https://es.wikipedia.org/wiki/Unidad_de_gesti%C3%B3n_de_memoria_de_entrada/salida?target=_blank)), lo que recibe el nombre de [passthrough](https://en.wikipedia.org/wiki/Passthrough_device?target=_blank).  
         + *Software (CPU y Memoria) - [Northbridge de las placas madre](https://es.wikipedia.org/wiki/Puente_norte?target=_blank):* instalación, carga y autenticación en aplicaciones.
         + *Kernel:* rotación de programas.

   - <u>EX342 - RedHat Linux Diagnostics and Troubleshooting :</u> catálogo de procedimientos de análisis clasificados y verificados por el fabricante.
   
+ **¿Cómo? - Establecer Protocolos de Diagnóstico:** las distintas herramientas del maletín se van a emplear en los protocolos de diagnóstico, que se elaboran adaptando protocolos preexistentes a las particularidades de cada institución (por ejemplo: [Ubuntu protocolo Touchpad](https://wiki.ubuntu.com/DebuggingTouchpadDetection?target=_blank), [IBM protocolo Chrony](https://www.ibm.com/support/pages/how-troublsehoot-chrony-issues?target=_blank)). Estos protocolos vienen a recolectar evidencias a lo largo de la cadena de eventos del problema que se quiere analizar. En medicina, si se quiere diagnosticar una enfermedad pulmonar, hay que conocer la anatomía del pulmón para determinar qué pruebas son necesarias en el protocolo de diagnóstico de estas enfermedades, y cada prueba utilizará una batería de herramientas de análisis. En Linux es muy similar, hay que conocer la anatomía de los subsistemas afectados y adaptar protocolos preexistentes a necesidades específicas de cada institución. La rapidez de respuesta en la resolución de incidencias depende de tener bien catalogados estos procedimeintos y resoluciones ante distintos fallos.
![Herramientas Análisis](image://intro/analisis.jpg)

# Ejemplos XR12
## Troubleshooting del Reloj
El reloj es uno de los subsistemas más simples que hay, un buen ejemplo para ver cómo se aplica esta metodología de trabajo. 
### Diagnóstico: Síntomas y Evidencias
#### ETAPA 1: Definición del Problema, Los Síntomas
En esta esta etapa, se describe la sintomatología, qué subsistemas están afectados y qué cadenas de eventos dentro de cada subsistema, circunscribiendo así los protocolos de diagnóstico necesarios en la fase de recolección de evidencias.

Esencial basarse en protocolos pre-existentes para establecer un protocolo ajustado a las necesidades específicas de una organización o un contexto de trabajo:
+ [NTP Debugging Unreachable Time Sources](https://kb.meinbergglobal.com/kb/time_sync/ntp/ntp_debugging/ntp_debugging_unreachable_time_sources?target=_blank)
+ [Basic chrony NTP troubleshooting](https://www.ibm.com/docs/en/storage-ceph/8.0.0?topic=issues-basic-chrony-ntp-troubleshooting?target=_blank)
+ [How to troubleshoot chrony issues](https://www.ibm.com/support/pages/how-troublsehoot-chrony-issues?target=_blank)

![Reloj: Sintomatología](image://teoria/reloj_etapa1.jpg)

#### ETAPA 2: Protocolo de Diagnóstico, Recopilar Evidencias
Se trata del subsistema de reloj de Linux. Aquí se aplican dos protocolos de diagnóstico:
+ **PROTOCOLO 1 - EVIDENCIAS COMUNES DE SUBSISTEMA:** es una parte común a todos los subsistemas linux, e involucra evidencias repecto al *"Mandatory Access Control (MAC)"* de entornos Linux, o sea, usuarios, permisos, firewall, selinux y políticas criptográficas. Toda aplicación está sometida a estos controles, eso puede bloquear su operativa; un porcentaje amplísimo de incidencias se resuelven rápidamente si se aplican estos protocolos relativos al MAC de entornos de ejecución Linux, de manera sistemática y lo más automatizada posible, ahorrando ingentes cantidades de tiempo y disgusto.
+ **PROTOCOLO 2 - EVIDENCIAS ESPECÍFICAS DE SUBSISTEMA:** una vez descartados los elementos comunes relativos al MAC, se aplican protocolos específicos de cada subsistema, en este caso el subsistema de reloj. Según la complejidad del subsistema, involucra más o menos cadenas de eventos, cada una de ellas con su protocolo de diagnóstico. La etapa 1 debe identifficar las cadenas afectadas de cada subsistema. 

Los resultados de esta etapa pueden ser dos:
+ **OPCIÓN 1 - Resolución del Problema:** a partir de la base de datos de incidencias resueltas donde se indica qué procedimientos hay que aplicar para resulver este problema, a la luz de estas evidencias que arroja el protocolo.
+ **OPCIÓN 2- Apertura de un Caso:** se ordenan las evidencias en un formato estándar, tal como ha de indicar el protocolo, y se abre una incidencia con fabricante. Una vez recibida la resolución, se guarda en una bsae de datos de incidencias indicando subsistema, cadena de eventos y punto de la cadena de eventos que se ha ocasionado la incidencia.

COMÚN SERVICIO LINUX               | ESPECÍFICO NTP
-----------------------------------|------------------------------------
![Subsistema: Evidencias MAC](image://teoria/reloj_etapa2c.jpg) | ![NTP: Evidencias Sincronismo](image://teoria/reloj_etapa2e.jpg) 
### Resolución: Hallazgos y Resultados
#### ETAPAS 3 Y 4: Formalizando Hallazgos, Crear y Verificar Hipótesis
HIPÓTESIS                          | TESIS 
-----------------------------------|------------------------------------
![Reloj: Hipótesis](image://teoria/reloj_hipotesis.jpg)|![Reloj: Tesis](image://teoria/reloj_tesis.jpg)

#### ETAPA 5: Resultados y su Documentación
##### Documento de Resultados
Así como el documento de definición tiene un ámbito privado, y admite formatos y herramientas definidas por cada equipo de trabajo, el documento de resultados sigue un formato estandarizado y se registra en algún sistema centralizado de gestión de anomalías, para que puedan ser vistas por todos los equipos de trabajo. En muchas ocasiones, una anomalía es bloqueante para otro equipo de trabajo. 

No es objeto de este documento tratar ni las normativas, ni procesos de calidad, ni herramientas relacionadas, por lo que este paso tan solo se deja indicado.

##### Análisis de Causa Raíz (RCA=Root Cause Analysis)
Este documento opcional se presenta cuando se requiere de alguna inversión. Por 
+ Documento Definición de Problema.
+ Impacto y análisis de riesgo para el sistema: 
  - Los sistemas ATM son sensible al sincronismo de reloj
  - Las aplicaciones fallan, la UCS puede quedar fuera de servicio.
+ Motivo real del incidente.
  - Bloqueo de la red por parte de un firewall.
+ Línea de tiempo de eventos y acciones tomadas.
  - Resumen gráfico de documento de definición. En este ejemplo, se omite.
+ Datos clave.
  - ntpdate ntpserver1 => No server suitable for synchronization.
+ Plan de acción para prevenir que el incidente vuelva a suceder.
  - Se recomienda sistema de monitorización y control de toda la red de manera centralidad, por ejemplo, soluciones tipo SDN (Software Define Network).