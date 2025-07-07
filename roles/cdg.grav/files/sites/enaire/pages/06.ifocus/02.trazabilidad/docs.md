---
title: Trazabilidad
taxonomy:
    category: docs
---

# Objetivos
Revisar un método de análisis de subsistemas Linux a través de un protocolo de diagnóstico simple, en el procesos ver cómo se  emplean los subsistemas de trazabilidad que tiene Linux.

+ [RedHat - Protocolo Diagnóstico Chrony](https://access.redhat.com/solutions/1259943?target+=_blank)
+ [IBM - Protocolo Diagnóstico Chrony](https://www.ibm.com/support/pages/how-troublsehoot-chrony-issues?target=_blank)
+ [Meinberg - Protocolo Diagnóstico NTP](https://kb.meinbergglobal.com/kb/time_sync/ntp/ntp_debugging/ntp_debugging_unreachable_time_sources?target=_blank)

# La Trazabilidad en Linux
## Subsistemas de Trazas y Auditoría
Tal como muestra la imagen, la trazabilidad del entorno de ejecución se basa en dos subsistemas:
+ **El subsistema de trazas estándar:** es el registro de actividad del- demonio de sistema. Traza los eventos relacionados con la administración de todos los programas del entorno de ejecución, como paradas, arranques, desconexiones de red, etc.
+ **El subsistema de auditoría:** es el registro de actividad del kernel. Mediante reglas personalizadas se puede hacer una introspección de la actividad de cada programa, trazando sus llamadas al sistema. Por cada regla de auditoría, el kernel genera un evento asociado a alguna llamada al sistema; cuando se dispara el evento, el núcleo se lo transmite a un demonio encargado de volcar dicho evento en una traza. 
![Entorno Ejecución](image://teoria/teoria-entorno.jpg)

## Trazas: RFC 5424 – Protocolo Syslog: El Formato de las Trazas
Red Hat Enterprise Linux incluye un sistema de registro estándar que se basa en el protocolo Syslog (RFC 5424). Muchos programas usan este sistema para registrar eventos y organizarlos en archivos de registro.
![Protocolo Syslog](image://teoria/teoria-entorno-syslog.jpg)

## Auditoría: Las Llamadas al Sistema
Para poder auditar las [llamadas al sistema](https://www.unix.com/man_page/posix/2/syscalls/?target=_blank) que hacen los programas, antes hay que conocerlas. Tal como muestra la imagen, se agrupan en dos familias, donde las más comunes dentro de la norma [POSIX (Portable Operating System Interface)](https://es.wikipedia.org/wiki/POSIX?¿target=_blank) son:

+ **Gestión de Procesos:** 
  - <u>Generación:</u> [fork](https://www.unix.com/man_page/sunos/2/fork/?target=_blank)/[exit](https://www.unix.com/man_page/mojave/n/exit/?target=_blank)/[kill](https://www.unix.com/man_page/minix/2/kill/?target=_blank)
  - <u>Ciclo de Vida:</u> [execve](https://www.unix.com/man_page/posix/2/execve/?target=_blank)
+ **Gestión de Recursos Entrada/Salida:**
  - <u>Ficheros (acceso al hardware):</u> [open](https://www.unix.com/man_page/centos/n/open/?target=_blank)/[close](https://www.unix.com/man_page/minix/2/close/?target=_blank)/[wait4](https://www.unix.com/man_page/mojave/2/wait4/?target=_blank), [read](https://www.unix.com/man_page/netbsd/2/read/?target=_blank)/[write](https://www.unix.com/man_page/suse/2/write/?target=_blank) 
  - <u>Comunicaciones (Sockets):</u> TX:{[listen](https://www.unix.com/man_page/sunos/1m/listen/?target=_blank)/[bind](https://www.unix.com/man_page/opensolaris/3socket/bind/?target=_blank)/[accept](https://www.unix.com/man_page/centos/3p/accept/?target=_blank)}, RX:{[connect](https://www.unix.com/man_page/sunos/3xnet/connect/?target=_blank)/[shutdown](https://www.unix.com/man_page/linux/3/shutdown/?target=_blank)}, [sendmsg](https://www.unix.com/man_page/centos/2/sendmsg/?target=_blank)/[recvmsg](https://www.unix.com/man_page/osf1/2/recvmsg/?target=_blank)

# Preparando la Maqueta
## Objetivo: Método Análisis de Subsistemas Linux
El objetivo del ejercicio es lograr que las máquina planificador y ejecutivo se sincronicen contra la máquina bastión que actúa como reloj maestro. Se completará sincronismo en planificadorA, dejando el ejecutivoA como práctica libre.
+ [Configurando Chrony](https://chrony-project.org/doc/3.4/chrony.conf.html?target=_blank)

## Desplegando Subsistema de Reloj
! Precaución: no pueden crearse varias maquetas a la vez en una misma máquina, antes hay que destruirlas con <code>vagrant destroy</code>
! Nota: Se asume el entorno está preparado siguiendo el procedimiento [Despliegue Maqueta](/06.ifocus/01.entorno)

En la máquina bastión como usuario <code>root (sudo -i)</code> (la contraseña <code>password</code>):
<div class="prism-wrapper"><pre class="language-bash"><code>
	 dnf install chrony -y
	 ssh root@planificadorA 'dnf install chrony -y'
     cd /vagrant/ejercicios/rhel/chrony/aislada
     \cp -f /etc/chrony.conf /etc/chrony.conf.orig
	 \cp -f chrony.master /etc/chrony.conf
	 scp chrony.client root@planificadorA:/etc/chrony.conf
	 systemctl restart chronyd
	 ssh root@planificadorA 'systemctl restart chronyd'
</code> </pre></div>

# Subsistema de Trazas Estándar
## Arquitectura
El subsistema de trazas de Linux tiene dos componentes:
+ **Registro Eventos:** el diario de sistema (journal) registra cada acción que realiza el demonio sistema, demonio que se ocupa de controlar el ciclo de vida de cada programa del sistema operativo. Además de la actividad del demonio de sistema, cada demonio tiene su propia traza que describe su actividad, en muchos casos el diario también da acceso a estas trazas. Las trazas del diario de sistema son efímeras en su configuración por defecto (desaparecen tras cada reinicio) y se guardan en binario por motivos de seguridad.
+ **Comunicaciones:** el demonio rsyslog recibe las trazas del diario de sistema, le aplica una serie de filtros y el resultado lo guarda en  <code>/var/log</code> de manera persistente. Diariamente se lanza el proceso <code>lorotate</code> que rota las trazas para que limitar el espacio que ocupan las trazas en disco. Es muy sencillo configurar el demonio Syslog para que transmita las trazas a un servidor central de trazas.
![Subsistema Trazas](image://teoria/teoria-entorno-trazas.jpg)

## Depurando el Demonio Chrony
### PROTOCOLO 1 - SUBSISTEMA: Mandatory Access Control
Se desactiva el MAC del entorno Linux, para eliminar elementos que pueden bloquear al subsistema bajo análsis.

1. **Desactivar Firewall**
<div class="prism-wrapper"><pre class="language-bash"><code>
        firewall-cmd --list-all
		systemctl stop firewalld
		systemctl status firewalld
		firewall-cmd --list-all
		ssh root@planificadorA 'firewall-cmd --list-all ; systemctl stop firewalld ; systemctl status firewalld ; firewall-cmd --list-all'
</code> </pre></div>

2. **Desactivar SELinux**
- *En Planificador A*
<div class="prism-wrapper"><pre class="language-bash"><code>
		ssh root@planificadorA "MODE=$(sestatus | grep -i current | awk -F: '{print $2}' | tr -d ' ') ; sed -i s/$MODE/disabled/g /etc/selinux/config ; cat /etc/selinux/config"  
		read -p "Do you wish to reboot planificarA (y/n)? " INPUT
		INPUT=$( echo ${INPUT} | tr '[:lower:]' '[:upper:]' )
		if [[ "${INPUT:0:1}" == "Y" ]] ; then ssh root@planificadorA 'reboot' ; fi
		if [[ "${INPUT:0:1}" == "S" ]] ; then ssh root@planificadorA 'reboot' ; fi
</code> </pre></div>

- *En Bastion*
<div class="prism-wrapper"><pre class="language-bash"><code>
        sestatus
		MODE=$(sestatus | grep -i current | awk -F: '{print $2}' | tr -d ' ')
        sed -i "s/$MODE/disabled/g"   /etc/selinux/config
		cat /etc/selinux/config
		read -p "Do you wish to reboot (y/n)? " INPUT
		INPUT=$( echo ${INPUT} | tr '[:lower:]' '[:upper:]' )
		if [[ "${INPUT:0:1}" == "Y" ]] ; then reboot ; fi
		if [[ "${INPUT:0:1}" == "S" ]] ; then reboot ; fi
</code> </pre></div>

3. **Desactivar Políticas Criptográficas**, en este caso, el perfil de políticas criptográficas DEFAULT no impone restricciones al cifrado de las comunicaciones de Chrony. Caso de existieran otras políticas que sí afectasen al cifrado de las comunicaciones del chrony, sí habría que desactivarlas
 - [Desactivar Poíticas Criptográficas](https://access.redhat.com/articles/7041246?target=_blank)
<div class="prism-wrapper"><pre class="language-bash"><code>
        update-crypto-policies --show
		ssh root@planificadorA 'update-crypto-policies --show'
</code> </pre></div>

### Reloj Maestro
#### PROTOCOLO 2 - CHRONY: Configuraciones
1. **Errores en el proceso de Arranque**, el demonio suele indicar si hay errores en los ficheros de configuración.
<div class="prism-wrapper"><pre class="language-bash"><code>
        cat /etc/chrony.conf
        systemctl status chronyd
		journalctl -u chronyd
</code> </pre></div>

En amarillo, aparece mensaje error relativo a nombres de host o direcciones IP: 
!!! Jun 26 09:41:24 bastion chronyd[3017]: Could not resolve address of initstepslew server ntpserver2
!!! Jun 26 09:41:24 bastion chronyd[3017]: Could not resolve address of initstepslew server ntpserver1
!!! Jun 26 09:41:24 bastion chronyd[3017]: commandkey directive is no longer supported

2. **Resolver Problemas de Configuración**, en este caso, direcciones IP.
<div class="prism-wrapper"><pre class="language-bash"><code>
        cat /etc/chrony.conf
        echo "\n" >> /etc/hosts		
        echo '192.168.56.149 ntpserver1.indra.lab ntpserver1' >> /etc/hosts
		echo '192.168.56.150 ntpserver2.indra.lab ntpserver2' >> /etc/hosts
		sed -i 's|allow 192.168.1.0/24|allow 192.168.56.0/24|g' /etc/chrony.conf
		sed -i 's|commandkey|#commandkey|g' /etc/chrony.conf
		cat /etc/chrony.conf
        systemctl restart chronyd
        systemctl status chronyd
		journalctl -u chronyd
</code> </pre></div>

#### PROTOCOLO 2 - CHRONY: Comunicaciones
+ [Comprobaciones NTP](https://seriot.ch/projects/tiny_ntp_client.html?target=_blank)

1. **Estado del Demonio**
<div class="prism-wrapper"><pre class="language-bash"><code>
        ss -tupln       | grep chrony
        netstat -tupln  | grep chrony
		lsof -i         | grep chrony
        chronyc sources
 		chronyc sourcestats
		chronyc tracking
</code> </pre></div>
 
2. **Prueba del Reloj Maestro con <code>ncat</code>**, se manda peticiones y se analiza el tráfico entrante.
+ *Consola 1, abrir escuchas TCP*, aquí se ver que entran peticiones NTP.
<div class="prism-wrapper"><pre class="language-bash"><code>
        dnf install tcpdump -y
		tcpdump -i any port 123 -vv
</code> </pre></div>

+ *Consola 2, envio de petición NTP*, se envían peticiones.
<div class="prism-wrapper"><pre class="language-bash"><code>
        printf c%47s |nc -uw1 bastion.indra.lab 123 |xxd -c4 -g4
		date --date=@$((0x`printf c%47s|nc -uw1 bastion.indra.lab 123|xxd -s40 -l4 -p`-64#23GDW0))
</code> </pre></div>

3. **Reactivación Firewall y comprobaciones**
<div class="prism-wrapper"><pre class="language-bash"><code>
        systemctl enable firewalld --now
		firewall-cmd --get-services 
        SERVICE=$(firewall-cmd --get-services | grep -E "ntp" | wc -l)
		
		# Si está definido el servicio en FirewallD
		if [ "$SERVICE" -gt "0" ] ; then 
		    firewall-cmd --info-service=ntp
			firewall-cmd --permanent --add-service=ntp
		    firewall-cmd --list-services
			
		# Puerto, si no está definido el servicio	
		else
		    firewall-cmd --permanent --add-port=123/udp
			firewall-cmd --list-ports
		fi
		
		# Comprobaciones
		ssh root@planificadorA 'printf c%47s |nc -uw1 bastion.indra.lab 123 |xxd -c4 -g4'
		sleep 1
		ssh root@planificadorA "date --date=@$((0x`printf c%47s|nc -uw1 bastion.indra.lab 123|xxd -s40 -l4 -p`-64#23GDW0))"
</code> </pre></div>

4. **Reactivación SELinux y comprobaciones**
+ *Reactivación SELinux*
<div class="prism-wrapper"><pre class="language-bash"><code>
        sestatus
		MODE=$(sestatus | grep -i current | awk -F: '{print $2}' | tr -d ' ')
        sed -i "s/$MODE/enforced/g"   /etc/selinux/config
		cat /etc/selinux/config
		read -p "Do you wish to reboot (y/n)? " INPUT
		INPUT=$( echo ${INPUT} | tr '[:lower:]' '[:upper:]' )
		if [[ "${INPUT:0:1}" == "Y" ]] ; then reboot ; fi
		if [[ "${INPUT:0:1}" == "S" ]] ; then reboot ; fi
</code> </pre></div>

+ *Comprobaciones*
<div class="prism-wrapper"><pre class="language-bash"><code>
		ssh root@planificadorA "printf c%47s |nc -uw1 bastion.indra.lab 123 |xxd -c4 -g4"
		sleep 1
		ssh root@planificadorA "date --date=@$((0x`printf c%47s|nc -uw1 bastion.indra.lab 123|xxd -s40 -l4 -p`-64#23GDW0))"
</code> </pre></div>

### Reloj Cliente
#### PROTOCOLO 2 - CHRONY: Configuraciones
1. **Errores en el proceso de Arranque**, el demonio suele indicar si hay errores en los ficheros de configuración. En este caso no hay errores en el fichero de configuración.
<div class="prism-wrapper"><pre class="language-bash"><code>
        ssh root@planificadorA	
        systemctl status chronyd
		journalctl -u chronyd
</code> </pre></div>

#### PROTOCOLO 2 - CHRONY: Comunicaciones
1. **Estado del Demonio**, en este caso no hay sincronización.
<div class="prism-wrapper"><pre class="language-bash"><code>
        ss -tupln       | grep chrony
        netstat -tupln  | grep chrony
		lsof -i         | grep chrony
        chronyc sources
 		chronyc sourcestats
		chronyc tracking
</code> </pre></div>

2. **Conectividad con Reloj Maestro**.
+ *No hay conectividad* 
<div class="prism-wrapper"><pre class="language-bash"><code>
         cat /etc/chrony.conf
		 ping ntpserver1
		 ping ntpserver2
		 cat /etc/hosts
</code> </pre></div>

+ *Se corrige /etc/hosts*
<div class="prism-wrapper"><pre class="language-bash"><code>
         echo "\n" >> /etc/hosts		
         echo '192.168.56.149 ntpserver1.indra.lab ntpserver1' >> /etc/hosts
		 echo '192.168.56.150 ntpserver2.indra.lab ntpserver2' >> /etc/hosts
		 sed -i 's|allow 192.168.1.0/24|allow 192.168.56.0/24|g' /etc/chrony.conf
		 ping ntpserver1
		 ping ntpserver2
		 cat /etc/hosts
</code> </pre></div>
 
+ *Comprobaciones*
<div class="prism-wrapper"><pre class="language-bash"><code>
        systemctl restart chronyd
        systemctl status chronyd   
        ss -tupln       | grep chrony
        netstat -tupln  | grep chrony
		lsof -i         | grep chrony     		
</code> </pre></div>

+ *Esperar y  compropar que se sincroniza*
<div class="prism-wrapper"><pre class="language-bash"><code>
        chronyc sources
 		chronyc sourcestats
		chronyc tracking  
		timedatectl
</code> </pre></div>

3. **Reactivación Firewall y comprobaciones**
<div class="prism-wrapper"><pre class="language-bash"><code>
        systemctl enable firewalld --now
		firewall-cmd --get-services 
        SERVICE=$(firewall-cmd --get-services | grep -E "ntp" | wc -l)
		
		# Si está definido el servicio en FirewallD
		if [ "$SERVICE" -gt "0" ] ; then 
		    firewall-cmd --info-service=ntp
			firewall-cmd --permanent --add-service=ntp
		    firewall-cmd --list-services
			
		# Puerto, si no está definido el servicio	
		else
		    firewall-cmd --permanent --add-port=123/udp
			firewall-cmd --list-ports
		fi
		
		# Comprobaciones
        chronyc sources
 		chronyc sourcestats
		chronyc tracking  
		timedatectl
</code> </pre></div>

4. **Reactivación SELinux y comprobaciones**
+ *Reactivación SELinux*
<div class="prism-wrapper"><pre class="language-bash"><code>
        sestatus
		MODE=$(sestatus | grep -i current | awk -F: '{print $2}' | tr -d ' ')
        sed -i "s/$MODE/enforced/g"   /etc/selinux/config
		cat /etc/selinux/config
		read -p "Do you wish to reboot (y/n)? " INPUT
		INPUT=$( echo ${INPUT} | tr '[:lower:]' '[:upper:]' )
		if [[ "${INPUT:0:1}" == "Y" ]] ; then reboot ; fi
		if [[ "${INPUT:0:1}" == "S" ]] ; then reboot ; fi
</code> </pre></div>

+ *Comprobaciones*
<div class="prism-wrapper"><pre class="language-bash"><code>
        chronyc sources
 		chronyc sourcestats
		chronyc tracking  
		timedatectl
</code> </pre></div>

#### PROTOCOLO 2 - CHRONY: Análisis de Trazas
1. **Ubicación de trazas**, en el planificadorA (cliente de sincronismo).
<div class="prism-wrapper"><pre class="language-bash"><code>
        tree /var/log
</code> </pre></div>

2. **Análisis de trazas**, siguiendo las indicaciones de la web:
+ [Análisis de trazas Chrony](https://kb.meinbergglobal.com/kb/time_sync/frequency_offset_and_drift?target=_blank)
<div class="prism-wrapper"><pre class="language-bash"><code>
        cat /var/log/chrony/*
</code> </pre></div>

# Subsistema de Auditoría
Se va a analizar las llamadas al sistema que hace el demonio Chrony en el cliente de sincronismo (planificadorA).

## Arquitectura 
![Subsistema Audit](image://teoria/teoria-audit-subsistema.jpg)

El sistema de auditoría que viene por defecto con Linus se compone de dos demonios:
+ **Demonio AuditD:** monitoriza los eventos activados a través de reglas de auditoría.
+ **Demonio AudispD:** permite comunicaciones con otras componentes. Especialmente importante cuando se quiere externalizar la telemetría a un servidor recoja las auditoría de muchos ordenadores y las integre en algún servicio de monitorización (por ejemplo: chkmk o Nagios). No se trata en esta documentación.

## Funcionalidad
Tal como muestra la imagen, cuando se registra una regla de auditoría, cada vez que suceda la condición descrita en la regla el kernel generará un evento. El evento se envía a un proceso de espacio de usuario (generalmente el auditd) a través de algo llamado socket "netlink". (El tl;dr en netlink es que le dice al kernel que envíe mensajes a un proceso a través de su PID, y los eventos aparecen en este socket).
![Funcionalidad Audit](image://teoria/teoria-audit-funcionalidad.jpg) 

## Auditando el demonio Chrony