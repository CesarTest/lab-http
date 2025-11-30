---
title: Comunicaciones
taxonomy:
    category: docs
---

# Subsistema Comunicaciones
## Bibliografía
+ [Subsistema NetworkManager](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/8/pdf/configuring_and_managing_networking/red_hat_enterprise_linux-8-configuring_and_managing_networking-en-us.pdf?target=_blank)
+ [Sustituiciones Palabras en Ficheros](https://www.theunixschool.com/2012/06/insert-line-before-or-after-pattern.html?target=_blank)

## Estructura
Las comunicaciones en Linux se basan en dos conceptos:
+ **Dispositivo:** cada una de las bocas de comunicaciones que tiene la máquina. El demonio UDEVD se encarga de la gestión de todos los dispositivos que se conectan a un sistema Linux.
+ **Conexión:** perfil de configuraciones que define un comportamiento de los dispositivos. El demonio NetworkManager gestiona las configuraciones que se asocian a cada dispositivo.

Las aplicaciones solo podrán abrir sockets cuando ambas componentes están ya configuradas en el sistema.

Durante el arranque del sistema, se sigue la siguiente secuencia de eventos:
1. **Demonio UDEV:** escanea todas las interfaces de red y asigna un nombre único a cada interfaz. Reporta todas las interfaces detectadas a NetworkManager.
2. **Demonio NetworkManager:** revisa todas las interfaces, si encuentra alguna interfaz sin conexión, crea una conexión temporal y se la asocia a la interfaz. 

Este proceso asegura tener disponible la interfaz de red nada más conectarla al sistema

Demonios                                                 | Configuración NMCLI
---------------------------------------------------------|-----------------------
![UDEV y NetworkManager](image://ifocus/red_demonios.jpg)| ![Coenxión Simple/Master-Slave](image://ifocus/red_nmcli.jpg)

## Configuración: Los ficheros de Conexión.
Tal como muestran las imágenes, existen dos procedimientos de configuración de conexiones:
+ **Conexión Simple:** se asocia un fichero de conexión a un dispositivo donde se indican las propiedades de red (dirección IP, etc.).
+ **Conexión Master-Slave:** se comienza por crear una conexión master, que genera un dispositivo virtual con su fichero de conexión asociado. A continuación en los ficheros de conexión de los dispositivos slave, en lugar de especificar una dirección IP, se índica que se conecten al dispositivo virtual de la conexión máster.

## Herramientas.
El subsistema NetworkManager trae varias herramientas para configurar interfaces de red, aunque no todos vienen instaladas en el sistema, tal vez requieran de paquetes adicionales:

NMCLI | NMTUI | NM-CONNECTION-EDITOR | NMSTATE
------|-------|----------------------|-------
<div class="prism-wrapper"><pre class="language-bash"><code>nmcli con show</code> </pre></div>|<div class="prism-wrapper"><pre class="language-bash"><code>nmtui</code></pre></div>|<div class="prism-wrapper"><pre class="language-bash"><code>nm-connection-editor</code></pre></div>|<div class="prism-wrapper"><pre class="language-bash"><code>nmstate --help</code></pre></div>


## Despliegue de Maqueta
! Precaución: no pueden crearse varias maquetas a la vez en una misma máquina, antes hay que destruirlas con <code>vagrant destroy</code>
! Nota: Se asume el entorno está preparado siguiendo el procedimiento [Despliegue Maqueta](/06.ifocus/01.entorno)

1. **Tener creadas tres sesiones MobaXterm**, una para cada máquina de la maqueta (192.168.56.149, 192.168.56.150, 192.168.56.151)
2. **Abrir terminal MobaXterm a cada máquina**, para poder comprobar que las máquinas se comunican entre sí simplemente cambiando de ventana.
3. **Eliminar Configuraciones de Red**, tanto en planificadorA como en ejecutivoA. Vagrant genera unas configuraciones de red muy específicas durante <code>vagrant up</code>, se deja una configuración similar a la de iFocus.
<div class="prism-wrapper"><pre class="language-bash"><code>
	   echo "==================> Install Extra Packages for Testing... [bride-utils]"
	   dnf install -y bridge-utils
       nmcli con show
	   sleep 2
	   
	   echo "==================> Deleting NMCLI Connections..."
	   sleep 2
	   CONNECTION=$(nmcli --get-values uuid,name con show | grep System | grep -v eth1 | awk -F: '{print $1}')
	   for CON in $CONNECTION ; do echo "nmcli con del $CON" ;  nmcli con del $CON ; done 
       nmcli con show	   
	   nmcli dev status
	   
	   echo "==================> Deleting Files at /etc/sysconfig/network-scripts..."
	   sleep 2
	   ls -la /etc/sysconfig/network-scripts
	   FILES=$(ls /etc/sysconfig/network-scripts | grep -v eth1)
	   for F in $FILES ; do echo "rm -f /etc/sysconfig/network-scripts/${F}" ; rm -f /etc/sysconfig/network-scripts/${F} ; done
	   ls -la /etc/sysconfig/network-scripts
   
	   echo "==================> Change NetworkManager Configuration File to avoid automatically Connection Files Creation..."
	   sleep 2
	   echo 'sed -i s!\[main\]!&\nno-auto-default=*!g /etc/NetworkManager/NetworkManager.conf'
	   sed -i 's!\[main\]!&\nno-auto-default=*!g' /etc/NetworkManager/NetworkManager.conf

	   echo "==================> Change Kernel Call at/boot/loader/entries Parameters to Activate UDEV names..."
	   sleep 2
       FILES=$(ls /boot/loader/entries/)
	   for F in $FILES ; do echo "sed -i s/net.ifnames=0/net.ifnames=1/g $F" ; sed -i 's/net.ifnames=0/net.ifnames=1/g' /boot/loader/entries/$F ; done
       cat   /boot/loader/entries/*
	   echo "---------------------------------------"
	   
	   echo "==================> Modify Network Connections..."
	   sleep 2
	   nmcli con mod eth0 ifname enp0s3 connection.id Vagrant 
	   nmcli con mod "System eth1" ifname enp0s8 connection.id Gestion 
 	   read -p "Do you wish to reboot (y/n)? " INPUT
	   INPUT=$( echo ${INPUT} | tr '[:lower:]' '[:upper:]' )
	   if [[ "${INPUT:0:1}" == "Y" ]] ; then reboot ; fi
	   if [[ "${INPUT:0:1}" == "S" ]] ; then reboot ; fi
</code></pre></div>

# Conexión Simple
## Ciclo de Vida con NMCLI
Al margen de procedimiento de configuración (simple o master-slave), en todos los casos hay que gestionar el ciclo de vida de los ficheros de conexión con <code>nmcli</code>, tal como muestra la imagen.
![Ciclo de Vida Fichero Conexión](image://ifocus/red_conexion.jpg)

## Status
Localizar interfaces de red sin configurar, tyanto en planificador como en ejecutivo.
<div class="prism-wrapper"><pre class="language-bash"><code>
      echo "==============> Interfaces sin configurar en color rojo"
      nmcli dev status
      sleep 2

      echo "==============> Interfaces con cable enchufado BROADCAST"
	  ip a
	  sleep 2
	  
	  echo "Se elige interfaz enp0s19 está roja (sin fichero conexión) y BROADCAST (tiene cable)"
</code></pre></div>

## Agregar
Se configura interfaz simple con parámetros mínimos (ifname, type, con-name) en eth7, que permanecerá amarilla porque no hay servidor DHCP activo y al tiempo pasará a blanca. 

+ **Planificador**
<div class="prism-wrapper"><pre class="language-bash"><code>
      echo "----------> Creando Interfaz de Red"
	  sleep 2
	  echo "nmcli con add con-name planificador-19 ifname enp0s19 type ethernet" 
      nmcli con add con-name "planificador-19" ifname enp0s19 type ethernet 
      nmcli con show  
	   
	  echo "----------> Revisando el Fichero de Conexión RHEL7/8 /etc/sysconfig/network-scripts/ifcfg-planificador-19*"
	  sleep 2
      cat /etc/sysconfig/network-scripts/ifcfg-planificador-19*
	  echo "----------> Revisando el Fichero de Conexión RHEL9 /etc/NetworkManager/system-connections/planificador-19*"
	  sleep 2
      cat /etc/NetworkManager/system-connections/planificador-19*	  
	  
	  echo "----------> Revisando modelo datos de Dispositivo /sys/class/net/enp0s19"
	  sleep 2
      ls -la /sys/class/net/enp0s19	  
</code></pre></div>

+ **Ejecutivo**
<div class="prism-wrapper"><pre class="language-bash"><code>
      echo "----------> Creando Interfaz de Red"
	  sleep 2
	  echo "nmcli con add con-name ejecutivo-19 ifname enp0s19 type ethernet" 
      nmcli con add con-name "ejecutivo-19" ifname enp0s19 type ethernet 
      nmcli con show  
	   
	  echo "----------> Revisando el Fichero de Conexión RHEL7/8 /etc/sysconfig/network-scripts/ifcfg-ejecutivo-19*"
	  sleep 2
      cat /etc/sysconfig/network-scripts/ifcfg-ejecutivo-19*	
	  echo "----------> Revisando el Fichero de Conexión RHEL9 /etc/NetworkManager/system-connections/ejecutivo-19*"
	  sleep 2
      cat /etc/NetworkManager/system-connections/ejecutivo-19*

	  echo "----------> Revisando modelo datos de Dispositivo /sys/class/net/enp0s19"
	  sleep 2
      ls -la /sys/class/net/enp0s19	  
</code></pre></div>

## Modificar 
Se asignana parámetros IP a la conexión.

+ **Planificador**
<div class="prism-wrapper"><pre class="language-bash"><code>
      echo "----------> Modificando Interfaz de Red"
	  sleep 2
	  echo "nmcli con mod planificador-19 ipv4.method manual ipv4.addresses 192.168.56.200/24" 
      nmcli con mod planificador-19 ipv4.method manual ipv4.addresses 192.168.56.200/24 
	   
	  echo "----------> Revisando el Fichero de Conexión RHEL7/8 /etc/sysconfig/network-scripts/ifcfg-planificador-19*"
	  sleep 2
      cat /etc/sysconfig/network-scripts/ifcfg-planificador-19*
	  echo "----------> Revisando el Fichero de Conexión RHEL9 /etc/NetworkManager/system-connections/planificador-19*"
	  sleep 2
      cat /etc/NetworkManager/system-connections/planificador-19*	  
	  
	  echo "----------> Comprobar si se ha recargado el fichero (o sea, se han aplicado los cambios)"
	  sleep 2
	  ip a 
</code></pre></div>

+ **Ejecutivo**
<div class="prism-wrapper"><pre class="language-bash"><code>
      echo "----------> Modificando Interfaz de Red"
	  sleep 2
	  echo "nmcli con mod ejecutivo-19 ipv4.method manual ipv4.addresses 192.168.56.201/24" 
      nmcli con mod ejecutivo-19 ipv4.method manual ipv4.addresses 192.168.56.201/24
      nmcli con show  
	   
	  echo "----------> Revisando el Fichero de Conexión RHEL7/8 /etc/sysconfig/network-scripts/ifcfg-ejecutivo-19*"
	  sleep 2
      cat /etc/sysconfig/network-scripts/ifcfg-ejecutivo-19*	
	  echo "----------> Revisando el Fichero de Conexión RHEL9 /etc/NetworkManager/system-connections/ejecutivo-19*"
	  sleep 2
      cat /etc/NetworkManager/system-connections/ejecutivo-19*
	  
	  echo "----------> Comprobar si se ha recargado el fichero (o sea, se han aplicado los cambios)"
	  sleep 2
	  ip a 	  
</code></pre></div>

## Conectar
Se aplican las modificaciones

+ **Planificador**
<div class="prism-wrapper"><pre class="language-bash"><code>
      echo "----------> Activando Configuraciones"
	  sleep 2
	  echo "nmcli con up planificador-19" 
      nmcli con up planificador-19 
	  
	  echo "----------> Comprobar que hay conectividad"
	  sleep 2
	  echo "................................ping 192.168.56.201 -I 192.168.56.200"	  	  
	  ping 192.168.56.201 -I 192.168.56.200
	  
	  echo "----------> Comprobaciones tráfico de red [enp0s19]"
	  echo "................................ethtool enp0s19"
	  ethtool enp0s19
	  echo "................................ip -s -d link show enp0s19"
	  ip -s -d link show enp0s19  
</code></pre></div>

+ **Ejecutivo**
<div class="prism-wrapper"><pre class="language-bash"><code>
      echo "----------> Activando Configuraciones"
	  sleep 2
	  echo "nmcli con up ejecutivo-19" 
      nmcli con up ejecutivo-19
	  
	  echo "----------> Comprobar si se ha recargado el fichero (o sea, se han aplicado los cambios)"
	  sleep 2
	  echo "................................ping 192.168.56.200 -I 192.168.56.201"	  
	  ping 192.168.56.200 -I 192.168.56.201
	  
	  echo "----------> Comprobaciones tráfico de red [enp0s19]"
	  echo "................................ethtool enp0s19"
	  ethtool enp0s19
	  echo "................................ip -s -d link show enp0s19"
	  ip -s -d link show enp0s19
</code></pre></div>

## Ejemplo: VLAN
+ **Objetivo:** Crear dos conexiones VLAN. 
+ **Resultado:** No hay conectividad porque es necsario habilitar bocas tipo "trunk" en los switches que transporten el tráfico etiquetado de una boca a la otra del switch. Los switches virtuales de VirtualBox no soportan esta propiedad, se requeriría maquinaria física, o switches virtuales más complejos. 

+ **Planificador**
<div class="prism-wrapper"><pre class="language-bash"><code>
      echo "----------> Creando conexión VLAN"
	  sleep 2
      echo "nmcli connection add con-name VLAN10 type vlan ifname vlan10 vlan.id 10 vlan.parent enp0s9"
      nmcli connection add con-name VLAN10 type vlan ifname vlan10 vlan.id 10 vlan.parent enp0s9 ipv4.method manual ipv4.addresses 192.168.1.180/24
	  nmcli con up VLAN10

      echo "----------> Comprobando Interfaz Virtual [ip a]"
	  sleep 2	  
	  ip a
	  
</code></pre></div>

+ **Ejecutivo**
<div class="prism-wrapper"><pre class="language-bash"><code>
      echo "----------> Creando conexión VLAN"
	  sleep 2
      echo "nmcli connection add con-name VLAN10 type vlan ifname vlan10 vlan.id 10 vlan.parent enp0s9"
      nmcli connection add con-name VLAN10 type vlan ifname vlan10 vlan.id 10 vlan.parent enp0s9 ipv4.method manual ipv4.addresses 192.168.1.181/24
	  nmcli con up VLAN10

      echo "----------> Comprobando Interfaz Virtual [ip a]"
	  sleep 2	  
	  ip a
	  
	  echo "----------> Comprobar si se ha recargado el fichero (o sea, se han aplicado los cambios)"
	  sleep 2 
	  echo "................................ping 192.168.56.180 -I 192.168.56.181"
	  ping 192.168.56.180 -I 192.168.56.181
	  
	  echo "----------> Comprobaciones tráfico de red [vlan10]"
	  echo "................................ethtool vlan10"
	  ethtool vlan10
	  echo "................................ip -s -d link show vlan10"
	  ip -s -d link show vlan10
</code></pre></div>

# Conexión Master-Slave
## Bond
Mismas operaciones en Planificador que en Ejecutivo, salvo que se especifique lo contrario.

### Conexión Master: Controlador Bonding Virtual
1. **Crear Agregador Virtual** donde tanto el nombre del dispositivo virtual, como su fichero de conexión donde están sus configuraciones se eligen libremente.
<div class="prism-wrapper"><pre class="language-bash"><code>
         echo "nmcli con add con-name Master ifname Bond-Ctrl type bond"
         nmcli con add con-name Master ifname Bond-Ctrl type bond
		 echo "nmcli con show"
		 nmcli con show
		 echo "ip a"
		 ip a
</code></pre></div>

2. **Revisar tanto Agregador Virtual como su Fichero de Conexión**
<div class="prism-wrapper"><pre class="language-bash"><code>
	     echo "----------> Dispositivo Virtual [Bond-Ctrl] en [/sys/class/net/Bond-Ctrl/]"
		 echo "ls -la /sys/class/net/Bond-Ctrl/"
		 ls -la /sys/class/net/Bond-Ctrl/
		 sleep 1

	     echo "----------> Estado en RAM del dispositivo virtual [Bond-Ctrl] en [/proc/net/bonding/Bond-Ctrl]"
		 echo "cat /proc/net/bonding/Bond-Ctrl"
		 cat /proc/net/bonding/Bond-Ctrl
		 sleep 1

	     echo "----------> Fichero Conexión [Master] en [/etc/sysconfig/network-scripts, /etc/NetworkManager/system-connections]"
		 echo "cat /etc/sysconfig/network-scripts/*Master*"
		 cat /etc/sysconfig/network-scripts/*Master*
		 echo "cat /etc/NetworkManager/system-connections/*Master*"
		 cat /etc/NetworkManager/system-connections/*Master*		 
</code></pre></div>

3. **Parámetros IP al Fichero de Conexión de Controlador Bonding**

+ *Planificador*
<div class="prism-wrapper"><pre class="language-bash"><code>
        echo "nmcli con mod Master ipv4.method manual ipv4.addresses 192.168.56.135/24"
        nmcli con mod Master ipv4.method manual ipv4.addresses 192.168.56.135/24
		echo "nmcli con up Master"
		nmcli con up Master
</code></pre></div>

+ *Ejecutivo*
<div class="prism-wrapper"><pre class="language-bash"><code>
        echo "nmcli con mod Master ipv4.method manual ipv4.addresses 192.168.56.135/24"
        nmcli con mod Master ipv4.method manual ipv4.addresses 192.168.56.136/24
		echo "nmcli con up Master"
		nmcli con up Master
</code></pre></div>

### Conexiones Slaves: NICs enchufadas a Controlador Bonding

1. **Dos Dispositivos sin Configurar y con cable**, en color rojo y BROADCAST.
<div class="prism-wrapper"><pre class="language-bash"><code>
         echo "nmcli dev status"
         nmcli dev status
		 echo "ip a"
		 ip a
</code></pre></div>


2. **Crear Fichero Conexión para esos dos dispositivos**, enp0s10, enp0s16.
<div class="prism-wrapper"><pre class="language-bash"><code>
         echo "nmcli con add con-name Slave1 ifname enp0s10 type ethernet slave-type bond	master Bond-Ctrl"
         nmcli con add con-name Slave1 ifname enp0s10 type ethernet slave-type bond	master Bond-Ctrl
		 echo "nmcli con add con-name Slave2 ifname enp0s16 type ethernet slave-type bond	master Bond-Ctrl"
         nmcli con add con-name Slave2 ifname enp0s16 type ethernet slave-type bond	master Bond-Ctrl
		 echo "nmcli con show"
		 nmcli con show	
		 echo "ip a  | grep master"
		 ip a | grep master
		 echo "cat /proc/net/Bond-Ctrl"
		 cat /proc/net/Bond-Ctrl
</code></pre></div>

3. **Prueba conectividad de los bonding**.

+ *Planificador*
<div class="prism-wrapper"><pre class="language-bash"><code>
         ping 192.168.56.136 -I 192.168.56.135
</code></pre></div>

+ *Ejecutivo*
<div class="prism-wrapper"><pre class="language-bash"><code>
         ping 192.168.56.135 -I 192.168.56.136
</code></pre></div>

## Switch Virtual
+ [Configuraciones Switch Virtual](https://developers.redhat.com/articles/2022/04/06/introduction-linux-bridging-commands-and-features?target=_blank)
`+ [Prueba Switches Virtuales](https://devtechs.readthedocs.io/en/latest/topics/virtualization/network-virtualization/linux-bridges.html?target=_blank)

Mismas operaciones en Planificador que en Ejecutivo, salvo que se especifique lo contrario.

### Conexión Master: Swicth Virtual
1. **Crear Agregador Virtual** donde tanto el nombre del dispositivo virtual, como su fichero de conexión donde están sus configuraciones se eligen libremente.
<div class="prism-wrapper"><pre class="language-bash"><code>
         echo "nmcli con add con-name MasterSw ifname MiConmutador type bridge"
         nmcli con add con-name MasterSw ifname MiConmutador type bridge
		 echo "nmcli con show"
		 nmcli con show
		 echo "ip a"
		 ip a
</code></pre></div>

2. **Revisar tanto Agregador Virtual como su Fichero de Conexión**
<div class="prism-wrapper"><pre class="language-bash"><code>
	     echo "----------> Dispositivo Virtual [MiConmutador] en [/sys/class/net/MiConmutador/]"
		 echo "ls -la /sys/class/net/MiConmutador/"
		 ls -la /sys/class/net/MiConmutador/
		 sleep 1

	     echo "----------> Estado del dispositivo virtual [MiConmutador]"
         echo "ip -j -p -d link show MiConmutador"		 
		 ip -j -p -d link show MiConmutador
		 sleep 1
		 
	     echo "----------> Fichero Conexión [MasterSw] en [/etc/sysconfig/network-scripts, /etc/NetworkManager/system-connections]"
		 echo "cat /etc/sysconfig/network-scripts/*MasterSw*"
		 cat /etc/sysconfig/network-scripts/*MasterSw*
		 echo "cat /etc/NetworkManager/system-connections/*MasterSw*"
		 cat /etc/NetworkManager/system-connections/*MasterSw*		 
</code></pre></div>

3. **Parámetros IP al Fichero de Conexión de Switch Virtual**

+ *Planificador*
<div class="prism-wrapper"><pre class="language-bash"><code>
        echo "nmcli con mod MasterSw ipv4.method manual ipv4.addresses 192.168.56.145/24"
        nmcli con mod MasterSw ipv4.method manual ipv4.addresses 192.168.56.145/24
		echo "nmcli con up MasterSw"
		nmcli con up MasterSw
		echo "nmcli con show"
		nmcli con show
		echo "ip a"
		ip a
</code></pre></div>

+ *Ejecutivo*
<div class="prism-wrapper"><pre class="language-bash"><code>
        echo "nmcli con mod MasterSw ipv4.method manual ipv4.addresses 192.168.56.146/24"
        nmcli con mod MasterSw ipv4.method manual ipv4.addresses 192.168.56.146/24
		echo "nmcli con up MasterSw"
		nmcli con up MasterSw
		echo "nmcli con show"
		nmcli con show
		echo "ip a"
		ip a		
</code></pre></div>


### Conexión Slaves: NICs enchufadas a Swicth Virtual

1. **Un Dispositivos sin Configurar y con cable**, en color rojo y BROADCAST.
<div class="prism-wrapper"><pre class="language-bash"><code>
         echo "nmcli dev status"
         nmcli dev status
		 echo "ip a"
		 ip a
</code></pre></div>


2. **Crear Fichero Conexión para esos dos dispositivos**, enp0s17.
<div class="prism-wrapper"><pre class="language-bash"><code>
         echo "nmcli con add con-name SlaveSw ifname enp0s17 type ethernet slave-type bridge	master MiConmutador"
         nmcli con add con-name SlaveSw ifname enp0s17 type ethernet slave-type bridge	master MiConmutador
		 echo "nmcli con show"
		 nmcli con show	
		 echo "ip a  | grep master"
		 ip a | grep master
		 
</code></pre></div>

3. **Agregar  interfaz tun/tap a loss switches virtuales**, igual que haría el hipervisor KVM.
<div class="prism-wrapper"><pre class="language-bash"><code>
	    echo "----------> Creación Tunel [vnet0] en [/sys/class/net/vnet0/]"        
		echo "ip tuntap add dev vnet0 mode tap"
        ip tuntap add dev vnet0 mode tap
		echo "ip link show vnet0"
		ip link show vnet0
		sleep 2
		
	    echo "----------> Agregar Tunel [vnet0] al Switch Virtual [MiConmutador]"
        echo "ip link set dev vnet0 master MiConmutador"		
		ip link set dev vnet0 master MiConmutador
		echo "ip link set dev vnet0 master MiConmutador"
		brctl show
		echo "brctl showmacs MiConmutador"
		brctl showmacs MiConmutador
		sleep 2
        
	    echo "----------> Crear una NIC virtual"		
        ip link add type veth 
</code></pre></div>

4. **Prueba Conectividad entre Máquinas Virtuales**, desde las interfaces tun/tap.




