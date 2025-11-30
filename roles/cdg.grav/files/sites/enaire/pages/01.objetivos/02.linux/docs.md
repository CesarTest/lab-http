---
title: Linux
taxonomy:
    category: docs
---

# Introducción
Se pretende dar una visión resumida y completa del sistema operativo Linux, sistema operativo en el que están basado los muebles iFocus.

# Arquitectura
## Componentes
El sistema operativo puede ser visto como un *gestor de programas*, multitud de programas (procesos o demonios) agrupados en subsistemas que crean un entorno de ejecución. Cada subsistema ofrece una serie de funcionalidades finales dentro de ese entorno.

En la imagen las dos partes del sistema operativo, el entorno de ejecución representado por un nido, y los subsistemas representados por los huevos dentro del nido:
![Arquitectura Linux](image://teoria/teoria-linux.jpg)

## Entorno de Ejecución 
**DEF.: El Entorno de Ejecución:** conjunto de recursos y herramientas comunes para administrar el ecosistema de programas.
   - <b>Estructura:</b> <u>kernel</u> para asignación automática de recursos hardware a cada programa y <u>demonio de sistema</u> que organiza el ecosistema de programas a través de unidades de ejecución (ficheros donde se describe cómo controlar el ciclo de vida de cada programa, en Linux hay dos variantes, el antiguo Init y el nuevo SystemD).
   - <b>Trazabilidad:</b> <u>auditoría</u> del kernel y <u>logs</u> o registros de actividad de los programas que administra el demonio de sistema.
   - <b>Software:</b> <u>repositorios</u>, las aplicaciones en linux se distribuyen en forma de paquetes a través de respositorios.Una serie de ficheros mantiene la base de datos de URLs donde conectarse para bajar esos paquetes.
   - <b>Seguridad:</b> las aplicaciones cuando van a acceder a los ficheros (los recursos de los sistemas informáticos) pasan por un *Mandatory Access Control (MAC)* que consta de tres elementos principales: 
        1. <u>Usuarios:</u> RBAC (Role Based Access Control) en Linux hay tres posibilidades:
		    - *PAM:* Pluggable Authentication Module... demonio que gestiona accesos de usuario (login).
            - *LDAP:* Lightweight Directory Access Protocol... gestión centralizada de usuarios para todo un centro de datos.
            - *AAA*: Authentication-Authorization-Accounting con protocolos como kerberos... gestión centralizada de usuarios que actúa como parquímetro de uso de recursos. 	
			
		2. <u>Ficheros:</u> control de acceso a ficheros con dos aproximaciones diferentes:
		    - *Capacidades Linux*: a nivel de recurso, las aplicaciones se "enjaulan" dentro de un usuario con permisos restringidos. [AppArmor](https://es.wikipedia.org/wiki/AppArmor?target=_blank) es una aplicación que permite organizar perfiles de capacidades (como ACLs -Access Control List-, etc.) para encapsularlas.
			- *SELinux*: a nivel de kernel, un etiquetado de ficheros agrega un nivel adicional de restricciones a las aplicaciones.
			
		3. <u>Comunicaciones:</u> control sobre las comunicaciones lo realizan dos elementos:
		    - *Firewall*: el núcleo de sistema incorpora un firewall llamado *iptables*, que suele controlarse de manera más sencilla a través del demonio *firewalld*, que se gestiona con el comando ```firewall-cmd```.
			- *Políticas Criptográficas*: políticas a nivel de todo el ecosistema de aplicaciones para gestionar qué le es permitido a las aplicaciones hacer y qué no.

## Subsistemas Principales
**DEF.: Subsistemas:** colección de demonios que cooperan para ofrecer una funcionalidad final.

 1. <b>Comunicaciones:</b> administración de dispositivos (*UDEV*) y configuraciones de red (*NetworkManager*). 
 2. <b>Virtualización contenedor:</b> etiquetado a nivel de kernel (namesapce en espacio usuario, cgroup en espacio de kernel) que permite crear entornos aisladas (*Podman* o *Docker*).
 3. <b>Virtualización máquina virtual:</b> Emulador Hardware (*QEMU*) y API control de instancias (*Libvirtd*).
 4. <b>Sistema gráfico:</b> representación gráfica mediante sistema cliente-servidor (*Xorg* que emplea recursos hardware del servidor; y *Wayland* que usa recursos hardware tanto del servidor como del cliente).
 5. <b>Reloj:</b> dos tipos de relojes: hardware (BIOS) y software (sistema operativo). El reloj de sistema puede sincronizarse con relojes maestros a través de los subsistema *NTP/Chrony* o *ptplinux*.

## Demonio: Proceso Servidor y Recursos de Entrada/Salida
El sistema operativo ejecuta programas sobre una máquina von Neumann, abstrae la gestión de la máquia a los programas a través de una interfaz de llamadas al sistema. Los programas en segundo plano reciben el nombre de demonios,  y son el ladrillo básico con el que se construye el entorno de ejecución.

**DEF.: Demonio:** es un Proceso Servidor (a la espera de atender peticiones de otros programas) y sus recursos de Entrada/Salida. En la imagen, se aprecia como los recursos de entrada/salida del demonio son ficheros y están en una ruta dentro del sistema de ficheros.

La estructura de carpetas que emplean los demonios es un estándar, aunque  se aprecian algunas diferencias según tipo de Unix:
+ <u>Rutas en cada Tipo Unix:</u> cada sistema Unix y cada distribución Linux tiene rutas diferentes.
+ <u>Rutas en Demonios de Entorno y de Demonios de Subsistema:</u> en RedHat, los demonios que sirven para gestionar el ecosistema de programas (demonios de entorno) suelen guardar sus datos persistentes en ```/usr``` (Unix System Resources), mientras que los demonios de los subsistemas suelen guardar sus datos persistentes en ```/var```.
+ <u>Logs de Unidades de Ejecución tipo Sesión y tipo Sistema:</u> con el nuevo demonio de sistema SystemD aparece la posibilidad de definir unidades de ejecución de Sesión de Usuario (que guarda sus logs en ```/home/<user>/.share/local```), y de Sistema (que guarda sus logs en ```/var/log```).
+ <u>Demonio UDEV:</u> el administrador de dispositivos de Linux mantiene dos carpeta específicas de la Entrada/Salida: ```/dev``` con ficheros de nodo, y ```/sys``` con el modelo de datos de acceso al hardware.

![Arquitectura Linux](image://teoria/teoria-demonio-estructura.jpg)

## Método de Exposición de Subsistemas

Para simplificar el estudio de cada subsistema se sigue la estructura de secciones que muestra la imagen: 

![Subsistema Linux](image://teoria/teoria-subsistema.jpg)

1. **Introducción al Subsistema**: su razón de ser. 
2. **Estructura del Subsistema**: la descripción de los demonios de los que se compone, con el siguiente esquema de secciones para cada uno de ellos:
  1. <u>¿Para qué el Demonio?</u> Rol dentro del componente
  2. <u>Anatomía</u>: rutas, tanto al ejecutable como a sus recursos. 
  3. <u>Configuración</u>: ficheros de configuración y parámetros más relevantes. Puede ampliarse consultando el manual de Linux.
  4. <u>Herramientas de Trabajo</u>: listado de ejecutables que ofrece el demonio.
  5. <u>(Opcional) Descripción Específicas</u>: algunos demonios requieren tratar algunas partes adicionales para comprender como usar las herramientas de trabajo.
  6. <u>Índice de Comandos</u>: resumen de comandos importantes, en una única página. 
  
3. **Funcionalidad del Subsistema**: casos de usos principales, abordando la mecánica de los procedimientos, sin entrar en detalles específicos.

# Diagnósticos

##  Administración de Sistemas

En el campo de la administración de sistemas existen estándares y normas que recogen sus áreas funcionales o responsabilidades:

+	**Recomendaciones ITU-T X.700:** marco de gestión para la interconexión de sistema abiertos en aplicaciones del CCITT (Comité Consultivo Internacional Telegráfico y Telefónico).
+	**ISO/IEC 10.040/1998:** Systems Management Overview.

![Administración de Sistemas](image://intro/administracion-sistemas.jpg)

Estos estándares distingues cinco áreas funcionales principales:
+	**Gestión de la Configuración:** velar por el control de versiones del software y la compatibilidad.l
+	**Gestión de Fallos:** mecanismos de detección, aislamiento, diagnóstico y corrección de averías de la red y condiciones de error.
+	**Gestión de Prestaciones:** métricas de rendimiento a fin de mantenerlos a unos niveles aceptables.
+	**Gestión de Contabilidad:** evaluar el uso de recursos y su coste, así como políticas de tarificación.
+	**Gestión de Seguridad:** control de acceso a los recursos para evitar accesos a información sensible o sabotajes.

Los procesos de Diagnóstico son necesarios en todas las áreas funcionales, ya que en todas se sigue el método científico. No obstante el mantenimiento de muebles iFocus está relacionada con diagnósticvos para la Gestión de Fallos.

##  Troubleshooting: El Método Científico
La imagen ilustra cómo distintas instituciones tecnológicas emplean un mismo método reproducible por cualquier persona en sus procesos de troubleshooting, estructurado en dos fases:
1.	**Diagnóstico (en rojo) – Síntomas y Evidencias:** definir síntomas y recopilar evidencias para describir génesis del problema, el estado del sistema y el impacto del problema. Para esta etapa, es esencial contar con buenos sistemas de trazabilidad y monitorización.
2.	**Resolución (en amarillo) – Hallazgos y Resultados:** bucle de ensayo/error verificando diferentes hipótesis sobre causas del problema. Reproducir el problema en un entorno controlado ayuda a la hora de formalizar hallazgos. Según la complejidad del entorno, esto puede implicar elaborar planes de acción y recuperación en cada iteración.

![Método Científico](image://intro/metodo.jpg)

##  Troubleshooting: Gestión Documental
Dado que los problemas suelen repetirse, se torna esencial documentar los casos, y clasificarlos de manera que se reduzcan al mínimo su número. Una clasificación por protocolo diagnóstico, puede simplificar esta base de datos, al ir agrupando “tema y variaciones”. 

Aparecen dos documentos diferentes:
+	**Diagnóstico - Documento de Definición:** el primer paso en el diagnóstico consiste en resumir la sintomatología de manera estructurada. A continuación, se van agregando las evidencias que los protocolos de diagnóstico van localizando. La base documental de otros casos se torna parte esencial. Ejemplo: [Bugzilla](https://bugzilla.redhat.com/?target=_blank)
+	**Resolución - Documento de Resultados:** una vez resuelta la anomalía, se resume toda la información relevante del caso, en herramientas especializadas como [IBM Rational Change](https://www.ibm.com/es-es/products/rational-change?target=_blank). El objetivo es coordinar equipos en distintas fases de desarrollo o mantenimiento, obtener métricas de tiempos y establecer métodos de actuación ante fallos a través de descripciones resumidas de:
   - a) Síntomas.
   - b) Pasos para la resolución.
   - c) Análisis de causa raíz (opcional, pero esencial cuando hay que depurar responsabilidades). 

![Gestión Documental](image://intro/docs.jpg)

##  Troubleshooting: Elaborando Protocolos de Diagnóstico
### Maletín Herramientas de Análisis: Arquitectura von Neumann
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

### Aplicando Protocolos de Diagnóstico

+ **La segunda etapa del diagnóstico consiste en recopilar evidencias**, aplicar los protocolos de diagnóstico establecidos en la etapa de análisis de síntomas.  Hay dos formas de aplicarlos:
  -	*Pruebas en Local,  Fin -> Principio:* evidencias de los últimos eventos descartan la necesidad de evidencias de los primeros.
  -	*Apertura de Caso, Principio -> Fin:* el especialista que tiene que hacer el análisis tal vez no pueda reproducir el problema, solo se basa en las evidencias que recibe. Será capaz de llegar antes a una hipótesis válida si puede descartar ciertas hipótesis en base a poder reconstruir la secuencia de eventos de principio a fin. 
+ **Los protocolos de diagnóstico son automatizables**, pudiendo incorporarse como parte de los mantenimientos establecidos en normativa de calidad.
+ **Evidencias de la secuencia de eventos se agregan al Documento de Definición**, que será el punto de partida de la fase de Resolución. El documento de definición ha de seguir un formato estandarizado, RedHat emplea la herramienta ```sosreport``` a estos efectos.
+ **Clasificación de resoluciones**, tras cada resolución de incidencia se indica en qué punto de la cadena falló y qué medidas hay que adoptar, estableciendo así un catálogo personalizado de modos de actuación ante los distintos fallos.