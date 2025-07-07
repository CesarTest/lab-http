---
title: Entorno
taxonomy:
    category: docs
---
<style>
	.enaire {
	   td, th {border: 1px solid #5AACFF;}
	   tr:hover {background-color: #ddd;}
       tr:nth-child(even){background-color: #EAF1FF;}
	   th {
          text-align: left;
          background-color: #5AACFF;
          color: white;	  
	   }
   }
</style>

# Introducción
## Arquitectura
El sistema operativo puede ser visto como un *gestor de programas*, multitud de programas (procesos o demonios) agrupados en subsistemas que crean un entorno de ejecución. Cada subsistema ofrece una serie de funcionalidades finales dentro de ese entorno.

En la imagen las dos partes del sistema operativo, el entorno de ejecución representado por un nido, y los subsistemas representados por los huevos dentro del nido. Esta serie de ejericios tiene como objetivo explorar lo elementos del entorno de un entorno de ejecución Linux.

**DEF.: El Entorno de Ejecución:** conjunto de recursos y herramientas comunes para administrar el ecosistema de programas.
- <b>Estructura:</b> <u>kernel</u> para asignación automática de recursos hardware a cada programa y <u>demonio de sistema</u> que organiza el ecosistema de programas a través de unidades de ejecución (ficheros donde se describe cómo controlar el ciclo de vida de cada programa, en Linux hay dos variantes, el antiguo Init y el nuevo SystemD).
- <b>Trazabilidad:</b> <u>auditoría</u> del kernel y <u>logs</u> o registros de actividad de los programas que administra el demonio de sistema.
- <b>Software:</b> <u>repositorios</u>, las aplicaciones en linux se distribuyen en forma de paquetes a través de repositorios.Una serie de ficheros mantiene la base de datos de URLs donde conectarse para bajar esos paquetes.
- <b>Seguridad:</b> las aplicaciones cuando van a acceder a los ficheros (los recursos de los sistemas informáticos) pasan por un *Mandatory Access Control (MAC)* que consta de tres elementos principales: 
  1. <u>Usuarios:</u> RBAC (Role Based Access Control) en Linux:
      - *PAM:* Pluggable Authentication Module... demonio que gestiona accesos de usuario (login).
  	
  2. <u>Ficheros:</u> control de acceso a ficheros con dos aproximaciones diferentes:
      - *Capacidades Linux*: a nivel de recurso, las aplicaciones se "enjaulan" dentro de un usuario con permisos restringidos. [AppArmor](https://es.wikipedia.org/wiki/AppArmor?target=_blank) es una aplicación que permite organizar perfiles de capacidades (como ACLs -Access Control List-, etc.) para encapsularlas.
  	- *SELinux*: a nivel de kernel, un etiquetado de ficheros agrega un nivel adicional de restricciones a las aplicaciones.
  	
  3. <u>Comunicaciones:</u> control sobre las comunicaciones lo realizan dos elementos:
      - *Firewall*: el núcleo de sistema incorpora un firewall llamado *iptables*, que suele controlarse de manera más sencilla a través del demonio *firewalld*, que se gestiona con el comando ```firewall-cmd```.
  	- *Políticas Criptográficas*: políticas a nivel de todo el ecosistema de aplicaciones para gestionar qué le es permitido a las aplicaciones hacer y qué no.
  
![Arquitectura Linux](image://teoria/teoria-linux.jpg)

## Despliegue de la maqueta
! Precaución: no pueden crearse varias maquetas a la vez en una misma máquina, antes hay que destruirlas con vagrant destroy
! Nota: Se asume el entorno está preparado siguiendo el procedimiento [Preparación Maqueta](/01.objetivos/03.maqueta)
1. **Desde Terminal MobaXterm local** 
2. **Limpiar Entorno Trabajo Virtual box**, en <code>C:\Users\<Usuario>\VirtualBox VMs</code> borrar subdirectorio <code>iFocus</code> si existiese.
3. **Clonar el repositorio Git**.
<div class="prism-wrapper"><pre class="language-bash"><code>
     git clone git@gitlab.proteo.internal:cdelgadog/ifocus.git
	 rm -Rf ifocus/.git 
     mv -f ifocus ifocus.lab	 
     cd ifocus.lab/vagrant-lab 
     vagrant up	 
</code> </pre></div>
4. **Crearse Conexiones MobaXterm a las tres máquinas**, bastion 192.168.56.149; planificadorA 192.168.56.150; ejecutivoA 192.168.56.151.
5. **Conectarse con MobaXterm a Máquina bastión**
<div class="prism-wrapper"><pre class="language-bash"><code>
     sudo -i
	 dnf install chrony -y
</code> </pre></div>

# Elementos
## Kernel: Estructura de un Demonio
![Arquitectura Linux](image://teoria/teoria-demonio-estructura.jpg)

### **Ficheros: Estructura de Carpetas** 
Todos los recursos de entrada/salida de un programa en linux es un fichero que se alamcena en una estructura estándar dentro del sistema de ficheros.

1. *El demonio, ¿en qué paquete viene?*
<div class="prism-wrapper"><pre class="language-bash"><code>
     dnf provides NetworkManager 
</code> </pre></div>

2. *¿Qué estructura interna tiene ese paquete?* Estructura de elementos del dibujo y en qué carpetas están.
<div class="prism-wrapper"><pre class="language-bash"><code>
     rpm -ql NetworkManager-1:1.45.7-1.el9.x86_64 
</code> </pre></div>

### **Sockets: Comunicaciones** 
Los sockets son descriptores de ficheros y se analizan con <code>ss</code>,<code>lsof</code> y <code>netstat</code>. 
[div class="table enaire"]
TCP/UDP        | IPC (Inter-Process)
---------------|--------------------
<div class="prism-wrapper"><pre class="language-bash"><code>ss -tuplen</code> </pre></div>| <div class="prism-wrapper"><pre class="language-bash"><code>ss -xplen</code> </pre></div>
<div class="prism-wrapper"><pre class="language-bash"><code>netstat -tuplen</code> </pre></div>| <div class="prism-wrapper"><pre class="language-bash"><code>netstat -xplen</code> </pre></div>
<div class="prism-wrapper"><pre class="language-bash"><code>lsof -i</code> </pre></div>| <div class="prism-wrapper"><pre class="language-bash"><code>lsof -U</code> </pre></div>
[/div]

### **Configuración**
1. **Ubicación de las Configuraciones**

[div class="table enaire"]
Persistentes   | Efímeras
---------------|--------------------
<div class="prism-wrapper"><pre class="language-bash"><code>ls /etc/NetworkManager</code> </pre></div>|<div class="prism-wrapper"><pre class="language-bash"><code>ls /run/NetworkManager</code> </pre></div>
[/div]

2. **Tipos de Configuración**
[div class="table enaire"]
Principal      | Modular
---------------|--------------------
<div class="prism-wrapper"><pre class="language-bash"><code>cat /etc/udev/udev.conf</code> </pre></div>|<div class="prism-wrapper"><pre class="language-bash"><code>ls /etc/udev/rules.d</code> </pre></div>
[/div]

## Demonio de Sistema: Unidades Ejecución
### **Base Datos Unidades de Ejecución**
!! **Nota:** si se emplea <code>sudo -i</code> o <code>su -</code> parea cambiar de usuario, la gestión de unidades de ejecuciión tipo usuario va a dar error. 

[div class="table enaire"]
Sistema        | Usuario
---------------|--------------------
<div class="prism-wrapper"><pre class="language-bash"><code>ls /usr/lib/systemd/system</code> </pre></div>|<div class="prism-wrapper"><pre class="language-bash"><code>ls /usr/lib/systemd/user</code> </pre></div>
[/div]

### La Unidad de Ejecución
#### **Aspecto**
[div class="table enaire"]
Systemctl      | Comando Bash
---------------|--------------------
<div class="prism-wrapper"><pre class="language-bash"><code>systemctl cat chronyd</code> </pre></div>|<div class="prism-wrapper"><pre class="language-bash"><code>cat /usr/lib/systemd/system/chronyd.service</code> </pre></div>
<div class="prism-wrapper"><pre class="language-bash"><code>systemctl --user cat bluetooth.target</code> </pre></div>|<div class="prism-wrapper"><pre class="language-bash"><code>cat /usr/lib/systemd/user/bluetooth.target</code> </pre></div>
[/div]

#### **Estado**
[div class="table enaire"]
Unidad         | Entorno
---------------|--------------------
<div class="prism-wrapper"><pre class="language-bash"><code>systemctl status chronyd</code> </pre></div>|<div class="prism-wrapper"><pre class="language-bash"><code>systemctl list-units</code> <code>systemctl list-unit-files</code></pre></div>
<div class="prism-wrapper"><pre class="language-bash"><code>systemctl --user status bluetooth.target</code> </pre></div>|<div class="prism-wrapper"><pre class="language-bash"><code>systemctl --user list-units</code><code>systemctl --user list-unit-files</code> </pre></div>
[/div]

#### **Activación durante el arranque del Ordenador**
Una estructura de enlaces simbólicos en <code>/etc/systmed/system</code> indican qué unidades deben ser encendidas durante el arranque del ordenador.
[div class="table enaire"]
<div class="prism-wrapper"><pre class="language-bash"><code>
    systemctl enable chronyd
	systemctl status chronyd
	ls -la /etc/systemd/system
    ls -la /etc/systemd/system/multi-user.target.wants/chronyd.service
</code> </pre></div>
[/div]

#### **Creación**
Se emplean unidades de ejecución tipo object, en este caso socket, al involucrar más elementos. Se usa la pareja <code>foo.socket</code> que levante un demonio a través de la unidad <code>foo.service</code>. Se sugiere repetir el ejemplo con la pareja <code>echo.socket</code> que levanta aun proceso a través de una unidad de ejecución transitoria <code>echo@.service</code>. 

1. **Copiar Unidad de Ejecución** a Destino
<div class="prism-wrapper"><pre class="language-bash"><code>
    cd /vagrant/ejercicios/rhel/systemd
	\cp -f foo.s* /usr/lib/systemd/system
</code> </pre></div>

2. **Recargar el Demonio de Sistema**
<div class="prism-wrapper"><pre class="language-bash"><code>
    systemctl daemon-reload
	systemctl list-sockets
</code> </pre></div>

3. **Comprobaciones**
<div class="prism-wrapper"><pre class="language-bash"><code>
    systemctl cat foo.socket
    systemctl status foo.socket
</code> </pre></div>

#### **Depuración**
Ver estado y estructura del fichero.

1. **Activando el Socket**
<div class="prism-wrapper"><pre class="language-bash"><code>
    systemctl start foo.socket
    systemctl status foo.socket
</code> </pre></div>

2. **Explorando el comando <code>ncat</code>** para verficar si un servicio está operativo.
[div class="table enaire"]
Manual         | Probando servidor HTTP
---------------|--------------------
<div class="prism-wrapper"><pre class="language-bash"><code>man ncat</code> </pre></div>|<div class="prism-wrapper"><pre class="language-bash"><code>echo -e "GET / HTTP/1.1\r\nHost: index.html\r\nConnection: close\r\n\r\n" &#124; ncat bastion.indra.lab 80</code> </pre></div>
[/div]

3. **Enviando petición con <code>ncat</code>**
<div class="prism-wrapper"><pre class="language-bash"><code>echo "Probando mi Servidor Echo" | ncat 127.0.0.1 9000</code> </pre></div>

4. **Depurar Unidad de Ejecución**, hasta localizar todos sus errores.
<div class="prism-wrapper"><pre class="language-bash"><code>
     systemctl status foo.socket
	 systemctl status foo.service
</code></pre></div>

+ *La clave del error se ve en la salida de <code>systemctl status foo.service</code>*, siguiente línea. Da a entener que la Unidad de Ejecución apunta a un fichero que no existe.
!! <div class="prism-wrapper"><pre class="language-bash"><code>Jun 25 14:52:26 bastion python3[1436]: /usr/bin/python3: can't open file '/root/root/systemd/foo.py': [Errno 2] No such file or di>en file '/root/root/systemd/foo.py': [Errno 2] No such file or directory</code></pre></div>

+ *Se corrige modificando la unidad de ejecución*
<div class="prism-wrapper"><pre class="language-bash"><code>
     cat /usr/lib/systemd/system/foo.service
     sed -i 's|%h/root/systemd/foo.py|/vagrant/ejercicios/rhel/systemd/foo.py|g' /usr/lib/systemd/system/foo.service
	 chmod +x /vagrant/ejercicios/rhel/systemd/foo.py
	 cat /usr/lib/systemd/system/foo.service
	 systemctl daemon-reload
	 systemctl reset-failed foo.service
	 systemctl restart foo.socket
	 systemctl daemon-reload
	 systemctl status foo.socket
	 systemctl status foo.service 
</code></pre></div>

+ *Se vuelve a mandar petición con <code>ncat</code>*
<div class="prism-wrapper"><pre class="language-bash"><code>
       systemctl stop firewalld
       echo "Probando mi Servidor Echo" | ncat 127.0.0.1 9000
</code> </pre></div>

!! NOTA: Se recomienda repetir el ejercicio para la pareja de unidades de ejecución <code>echo&#64;.service</code> y <code>echo.socket</code>

#### **Seguridad**
[div class="table enaire"]
Unidad         | Entorno
---------------|--------------------
<div class="prism-wrapper"><pre class="language-bash"><code>systemd-analyze security chronyd</code> </pre></div>|<div class="prism-wrapper"><pre class="language-bash"><code>systemd-analyze security</code></pre></div>
[/div]

#### **Nivel de Trazas**, de todo el entorno de ejecución
<div class="prism-wrapper"><pre class="language-bash"><code>
        systemd-analyze get-log-level
		systemd-analyze set-log-level 7
		systemd-analyze get-log-level
</code> </pre></div>

### **Niveles de Ejecución**
#### **Targets**, colección de Unidades de Ejecución
1. **Equivalencias con Init**
<div class="prism-wrapper"><pre class="language-bash"><code>
        ls -la /etc/lib/systemd/system/runlevel*
</code> </pre></div>

2. **Cambio de nivel de Ejecución**
<div class="prism-wrapper"><pre class="language-bash"><code>
        systemctl isolate multi-user.target
		who -r
		systemctl list-dependencies graphical.target
</code> </pre></div>

3. **Restauración de nivel de Ejecución**
<div class="prism-wrapper"><pre class="language-bash"><code>
        systemctl isolate graphical.target
		who -r
		systemctl list-dependencies graphical.target
</code> </pre></div>

#### **Target del Arranque del Sistema**
<div class="prism-wrapper"><pre class="language-bash"><code>
        systemctl set-default graphical.target
		ls -la /etc/systemd/system/default
</code> </pre></div>

#### **Análisis del proceso de Arranque**
<div class="prism-wrapper"><pre class="language-bash"><code>
        systemd-analyze
		systemd-analyze blame
		systemd-analyze critical-chain
		systemd-analyze plot > $HOME/boot.svg
</code> </pre></div>