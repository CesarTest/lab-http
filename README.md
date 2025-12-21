# Ejercicios Automatización UnderCloud

## PART 1: LEVANTAR MAQUETA VAGRANT... desde MobaXterm	

### Preparando el Ordenador Personal

#### A) Requisitos Hardware Mínimos 
- Procesador: No demasiado antiguo
- RAM: 16 GB
- Disco Duro: 150 GB libres

#### B) Requisitos Software 
- **Acceso a Internet**: Indispensable para acondicionar las Máquinas Virtuales.
- [Windows 10/11](https://www.microsoft.com/es-es/software-download/windows11)
- [VirtualBox >7](https://www.virtualbox.org/wiki/Downloads)
- [Vagrant](https://developer.hashicorp.com/vagrant/install?product_intent=vagrant)
- [MobaXterm](https://mobaxterm.mobatek.net/download.html)
- [Paquetes MobaXterm: Git y Ansible](https://mobaxterm.mobatek.net/plugins.html) 

### Levantando la Maqueta

#### Pasos para el despliegue de Maqueta
! Precaución: no pueden crearse varias maquetas a la vez en una misma máquina, antes hay que destruirlas con vagrant destroy

+ 1. **Abrir Termina MobaXterm local** 

+ 2. **Limpiar Entorno Trabajo Virtual box**, en <code>C:\Users\<Usuario>\VirtualBox VMs</code> borrar subdirectorio <code>GitOps_Lab</code> si existiese.

+ 3. **Configurar repositorio GitHub**, 
  - a) Crear cuanta GitHub y hacer un fork del repositorio <a target="_blank" href="https://github.com/CesarTest/lab">https://github.com/CesarTest/lab</a>
  - b) Credeciales SSH de acceso, crear llave ssh en local y subirla al repositorio
 <a target="_blank" href="https://docs.github.com/en/authentication/connecting-to-github-with-ssh/adding-a-new-ssh-key-to-your-github-account">https://docs.github.com/en/authentication/connecting-to-github-with-ssh/adding-a-new-ssh-key-to-your-github-account</a>

+ 4. **Clonar el repositorio Git**, usar el repositorio fork en lugar del ejemplo.
<div class="prism-wrapper"><pre class="language-bash"><code>
     git clone git@github.com:CesarTest/lab.git
</code> </pre></div>

+ 5. **Levantar la maqueta**
<div class="prism-wrapper"><pre class="language-bash"><code>
     cd lab/vagrant-lab 
     vagrant up
</code> </pre></div>

## PART 2: DESPLEGAR LA WEB... desde WLS

+ 1. **Instalar ansible y dependencias en WLS**
<div class="prism-wrapper"><pre class="language-bash"><code>
 sudo apt update && sudo apt upgrade -y
 sudo apt install python3-pip git libffi-dev libssl-dev ansible -y
</code> </pre></div>

+ 2. **Clonar Repositorio GIT** en WLS
<div class="prism-wrapper"><pre class="language-bash"><code>
     sudo -i
     git clone git@github.com:CesarTest/lab-http.git
</code> </pre></div>
 
+ 3. **Agregar URLs** a WLS
<div class="prism-wrapper"><pre class="language-bash"><code>
     echo '
      192.168.56.149 vcloud.maas.lab
      192.168.56.149 training.maas.lab' >> /etc/hosts
</code> </pre></div>

+ 4. **Relaciones de confianza SSH**
<div class="prism-wrapper"><pre class="language-bash"><code>
  ssh-copy-id vagrant@192.168.56.149 # password vagrant
  ssh-copy-id vagrant@192.168.56.150 # password vagrant
  ssh-copy-id vagrant@192.168.56.151 # password vagrant
  cd lab-http
  ansible -m ping all
</code> </pre></div>
 
+ 5. **Gestion de Dependencias**
<div class="prism-wrapper"><pre class="language-bash"><code>
  cd lab-http
  ansible-galaxy role install -r roles/requirements.yml
</code> </pre></div>

+ 6. **Descarga Paquetes**
<div class="prism-wrapper"><pre class="language-bash"><code>
  cd lab-http/roles/cdg.grav/files
  chmod +x download.sh
  ./download.sh
</code> </pre></div>

+ 7. **Instalar Web** 
<div class="prism-wrapper"><pre class="language-bash"><code>
  cd lab-http
  ansible-playbook playbooks/services.yaml
</code> </pre></div>

+ 8. **Acceso a la Web**
- 8.1. Editar C:\Windows\System32\drivers\etc\hosts, agregar líneas
<div class="prism-wrapper"><pre class="language-bash"><code>
192.168.56.149 training.maas.lab
192.168.56.149 vcloud.maas.lab
</code> </pre></div>

- 8.2.- Navegador Web http://training.maas.lab



