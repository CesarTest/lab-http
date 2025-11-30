---
title: Comandos
taxonomy:
    category: docs
---

# Introducción
## Formato PDF
+ [Comandos Linux](procedimientos.pdf?target=_blank)
+ [Phoenix Lab](https://phoenixnap.com/kb/wp-content/uploads/2023/11/linux-commands-cheat-sheet-pdf.pdf?target=_blank)

## Formato Web
+ [Comandos KVM](https://libguestfs.org/?target=_blank)
+ [Comandos Linux](https://phoenixnap.com/kb/linux-commands-cheat-sheet?target=_blank)

# Entorno Ejecución
## Gestión Software
 
## Demonio de Sistema
+ **Control de Unidad de Ejecución**
[div class="table table-striped demonio"]
COMANDO                                                        |  OBJETIVO                                           
---------------------------------------------------------------|---------------------------------------------------
<pre class="language-bash"><code>systemctl status {unit}</code></pre> | Descripción Unit
<pre class="language-bash"><code>systemctl stop {unit} </code></pre>  | Parar Unit
<pre class="language-bash"><code>systemctl start {unit}</code></pre>  | Arrancar Unit
<pre class="language-bash"><code>systemctl restart {unit}</code></pre>| Reiniciar Units
<pre class="language-bash"><code>systemctl reload {unit}</code></pre> | Recargar Unit
<pre class="language-bash"><code>systemctl enable {unit}</code></pre> | Habilitar Unit (+symlink <code>/etc/systemd</code>)
<pre class="language-bash"><code>systemctl disable {unit}</code></pre>| Deshabilitar Unit (-symlink <code>/etc/systemd</code>)
<pre class="language-bash"><code>systemctl mask {unit}</code></pre>   | Inhibir Unit (+symlink <code>/dev/null</code>)
<pre class="language-bash"><code>systemctl unmask {unit}</code></pre> | Habilitar Unit (-symlink <code>/dev/null</code>)
<pre class="language-bash"><code>systemctl show {unit}</code></pre>   | Propiedades de la Unit
<pre class="language-bash"><code>systemctl cat {unit}</code></pre>    | Ver fichero Unit
<pre class="language-bash"><code>systemctl edit --full {unit}</code></pre>      | Editar fichero de Unit
<pre class="language-bash"><code>systemctl -H <host> status {unit}</code></pre> | Comando SystemD por SSH
[/div]

+ **Control Entorno de Ejecución**
[div class="table table-striped demonio"]
COMANDO                                                        |  OBJETIVO                                           
---------------------------------------------------------------|---------------------------------------------------
<pre class="language-bash"><code>ls -la /usr/lib/systemd/system/run*.target </code></pre> | Niveles de ejecución existentes  
<pre class="language-bash"><code>systemdctl isolate {target} </code></pre> | Cambio nivel de ejecución 
<pre class="language-bash"><code>systemctl list-dependencies</code></pre>| Árbol de Dependencias
<pre class="language-bash"><code>systemctl list-sockets</code></pre>     | Listado Sockets
<pre class="language-bash"><code>systemctl list-jobs</code></pre>        | Jobs SystemD activos
<pre class="language-bash"><code>systemctl list-unit-files</code></pre>  | Modo arranque Units
<pre class="language-bash"><code>systemctl list-units</code></pre>       | Status Entorno Ejecución
<pre class="language-bash"><code>systemctl get-default</code></pre>      | Default Target
<pre class="language-bash"><code>systemctl set-default {target}</code></pre>| Configurar Default Target
<pre class="language-bash"><code>systemctl daemon-reload</code></pre>    | Refresco Units y Dependencias
<pre class="language-bash"><code>systemctl --failed</code></pre>         | Unit que fallaron
<pre class="language-bash"><code>systemctl reset-failed</code></pre>     | Reseteo de Units que fallaron
<pre class="language-bash"><code>systemctl reboot</code></pre>           | Reiniciar Máquina
<pre class="language-bash"><code>systemctl poweroff</code></pre>         | Apagar Máquina
<pre class="language-bash"><code>systemctl emergency</code></pre>        | Single User Mode
<pre class="language-bash"><code>systemctl default</code></pre>          | Volver al target por defecto.
<pre class="language-bash"><code>systemd-analyze get-log-level</code></pre> | Nivel de trazas en Systemd.
<pre class="language-bash"><code>systemd-analyze set-log-level {1-7}</code></pre> | Configurar Nivel de trazas en Systemd.
<pre class="language-bash"><code>systemd-analyze security</code></pre>   | Estado de la Seguridad de los servicios
<pre class="language-bash"><code>systemd-analyze critical-chain {unit} </code></pre>   | Secuencia de arranque de una Unidad de Ejecución
<pre class="language-bash"><code>systemd-analyze blame </code></pre>   | Análisis de tiempos del proceso de arranque
<pre class="language-bash"><code>systemd-analyze plot > boot.svg </code></pre>   | Análisis gráfico de tiempos del proceso de arranque
[/div]

## Trazas
+ **Entrada: Origen de la traza**
[div class="table table-striped demonio"]
COMANDO                                                              |  OBJETIVO                                           
---------------------------------------------------------------------|---------------------------------------------------
<pre class="language-bash"><code>journalctl -f</code></pre>   |Eventos en tiempo real
<pre class="language-bash"><code>journalctl -p {level}</code></pre> | Eventos de Prioridad:<ul><li>0=emerg</li><li>1=alert</li><li>2=crit</li><li>3=err</li><li>4=warning</li><li>5=notice</li><li>6=info</li><li>7=debug</li></ul>  
<pre class="language-bash"><code>journalctl -b</code></pre>   | Eventos del arranque
<pre class="language-bash"><code>journalctl -u {unit}</code></pre>  | Eventos de una Unit
<pre class="language-bash"><code>journalctl -k</code></pre> |Eventos del kernel
<pre class="language-bash"><code>journalctl --since <date> --until {date}</code></pre> | Eventos desde/hasta:<ul><li>“yesterday”</li><li>“2 days ago”</li><li>“1 hour ago”</li><li>“09:00”</li><li>“2024-05-17 13:15:30”</li></ul>
<pre class="language-bash"><code>journalctl {origen}={valor}</code></pre> | Eventos cuyo origen puede ser:<ul><li>_PID (proceso) </li> <li>_UID (usuario)</li><li>_GID (grupo usuarios)</li><li>_HOSTNAME</li><li>_COMM (comando)</li><li>_SELINUX_CONTEXT</li></ul>
<pre class="language-bash"><code>journalctl --flush</code></pre> | Elimina todos los ficheros de journal
<pre class="language-bash"><code>journalctl --rotate</code></pre> | Fuerza rotado de ficheros journal
<pre class="language-bash"><code>journalctl --vacuum-size={s} --vacuum-time={t} --vacuum-files={f}</code></pre> | Elimina los archivos de diario archivados más antiguos hasta el umbral especificado (tamaño, tiempo o número de ficheros). 
[/div]

+ **Salida: Formato de Presentación**
[div class="table table-striped demonio"]
COMANDO                                                              |  OBJETIVO                                           
---------------------------------------------------------------------|---------------------------------------------------
<pre class="language-bash"><code>journalctl -F</code></pre> |Eventos en tiempo real, deteniendo la salida cuando se detiene la entrada.
<pre class="language-bash"><code>journalctl -o {format}</code></pre> | Formato Salida:<ul><li>short</li><li>short-full</li><li>verbose</li><li>json-pretty</li><li>export</li></ul>  
<pre class="language-bash"><code>journalctl -x</code></pre> | Formato Extendido.
<pre class="language-bash"><code>journalctl -r</code></pre> | Formato Orden Inverso
<pre class="language-bash"><code>journalctl -t</code></pre> |Formato TImeStamp
<pre class="language-bash"><code>journalctl -n {num}</code></pre>| Formato con Número limitado de Eventos
<pre class="language-bash"><code>journalctl -e</code></pre> |Formato con todos los Eventos, incluso los eliminados
[/div]

## Auditoría

## Mandatory Access Control (MAC)

### Usuarios

### Recursos

#### Hardware

#### Ficheros

### Comunicaciones

# Subsistemas

## Reloj

## Comunicaciones

## Virtualización