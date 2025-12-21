---
title: Objetivos
taxonomy:
    category: docs
---

# MaaS (Metal as a Service): Gestión UnderCloud 

## Despliegue de Infraestructura: Integrando Piezas

El despliegue de infraestructuras de computación implica integrar un catálogo amplio y complejo de piezas, imposible de realizar sin una gestión automatizada del UnderCloud. Es habitual subestimar tanto su importancia como su complejidad, al no ser funcionalidad final, sino su puesta en funcionamiento.   

## Arquitectura de la Automatización

+ **MaaS - Metal as a Service:** interfaz que ofrece la frontera norte del controlador de automatización que permite:
 - *Modelar la infraestructura que se quiere gestionar*, abstrayendo características específicas del hardware subyacente. 
 - *Sistematizar la integración de configuraciones* en estrategias de despliegue en repositorio Git.
+ **API Infraestructura:** interfaz que ofrecen las componentes de la infraestructura al controlador de automatización en su frontera sur. 
  - Inversiones importantes y durante muchso años han terminado abandonadas ante la imposibilidad de lograr una estandarización en frontera sur de gestión de las componentes de infraestructura (proyectos como Equinix Metal o AT&T Airship). 
  - OpenStack y Kubernetes son las comunidades que están logrando una mayor estandarización en la automatización, por su lado RedHat iene estableciendo una frontera sur para componentes del sistema operativo en Ansible Automation Hub.

![Arquitectura de Automatización](image://intro/automatizacion.jpg)

# Caso Uso: Infraestructura de Factorías Software

## A.- Despliegue Automatizado de Fábricas Software

### A.1.- Ciclo de Vida de Kubernetes: Cluster API 

1. **[Kubernetes Cluster API](https://cluster-api.sigs.k8s.io/?target=_blank)** es una interfaz estándar para gestionar el ciclo de vida de clústeres kubernetes sobre cualquier tipo de infrastructura (física o virtualizada) en una modalidad GitOps que facilita su automatización.
2. **[Metal3](https://metal3.io/?target=_blank) permite a Cluster API gestionar clústeres sobre un tipo de infraestructura específica: la infraestructura física.** Para ello ofrece una interfaz estándar de CDRs (Custom Resources Definition) que se integra bien con Cluster API.
3. **[Ironic](https://ironicbaremetal.org/?target=_blank) es la pieza de Metal3 que gestiona las máquinas físicas durante los despliegues.** Ofrece una interfaz nativa OpenStack para hablar con el resto de componentes de OpenStack. Metal3 ha desarrollado un Baremetal Operator que adapta la interfaz que ofrece Ironic a la interfaz de CDRs que necesita Cluster API.

![Estrategias Despliegue](image://intro/k8s_api.jpg)

### A.2.- El rol de Metal3 en las Fábricas OpenShift

+ **Kubernetes Cluster API es una pieza estandarizada** del propio proyecto kubernetes que aspira a gestionar todo tipo de clúster (OpenShift, OKD, Rancher, etc.) sobre cualquier infraestructura física o virtualizada.
+ **Se espera que todas las fábricas software desplieguen sus entornos de trabajo Cluster API.** 
+ **RedHat e IBM apuntan hacia una infraestructura hiperconvergente sin virtualización** donde Metal3 es componente fundamental para la gestión del ciclo de vida de los clústeres.

## B.- Formación en Gestión de Infraestructuras
 
### B.1.- Objetivos

+ **Acelerar Formación:** el UnderCloud es mucho más complejo de lo que aparenta, requiere de una formación específica que se procura acelerar mediante estos ejercicios.
+ **Estándarés de Trabajo permite la integración de piezas:** RedHat está elaborando estándares que permiten integrar el trabajo de los distintos fabricantes. Objetivo de estos ejercicios mostrar estos estándares para poder formalizar políticas de trabajo que puedan ser aplicadas por equipos de automatización facilitando la consolidación de las configuraciones en estrategias de despliegue. 

### B.2.- Planificación
+ **PASO 1: Automatización GitOps:** ejercicios que acercan las nociones básicas sobre gestión de infraesrtuctura física o virtual. Se levantará un servidor PXE para entender de manera exhaustivo los procesos de gestión de máquinas físicas.
+ **PASO 2: Ironic:** aprovisionamiento de máquinas físicas... control del ciclo de vida una máquina desde un respotorio GIT gracias a la API de Ironic.
+ **PASO 3: Metal3:** despliegue de clústeres con Metal3... control del ciclo de vida de un racimo de máquinas desde repositorio Git gracias a Cluster API.
+ **PASO 4: Estrategias de Despliegue:** cómo gestionar un repositorio de configuraciones para integrarlas de manera orgánica, incluyendo los vitales mecanismos de herencia... en suma, control del ciclo de vida de una red de clústeres, se toma como referencia el proyecto [OSM](https://osm.etsi.org/?target=_blank) de [ETSI](https://www.etsi.org/?target=_blank).

## C.- Referencias: Guías para la Implementación

Una vez involucrados los conceptos básicos es importante la toma de contacto con proyectos de altos estándares de automatización que puedan servir de referencia, entre los que destacan:
+ **[OSM](https://osm.etsi.org/?target=_blank):** donde están desarrollando estándares para la comunidad Telco de creación y gestión de estrategias de despliegue. Director del proyecto [Francisico Javier Ramón Salguero](https://portal.etsi.org/tb.aspx?tbid=845&SubTB=845#/?target=_blank).
+ **[Anuket Pharos Lab](https://anuket.io/news/?target=_blank):** comunidad abierta con altos estándares de automatización para poder desplegar entornos de pruebas con cualquier combinación de tecnologías que use cada operadora de red en sus infraestructuras. Directora del proyecto es 
[Heather Kirksey](https://www.silverliningsevents.com/person/heather-kirksey?target=_blank)
+ **[Airship](https://www.airshipit.org/?target=_blank):** proyecto de AT&T para gestionar una red de centros de datos a partir de un repositorio de estrategias de despliegue desde las cabeceras de región. Aunque el desarrollo haya sido interrumpido, la gestión de documentos YAML con sistemas de herencias tiene conceptos muy relevantes para la integración de configuraciones en estrategias de despliegue de infraestructura. Arquitecto del proyecto es [Rodolfo Pacheco](https://wiki.openstack.org/wiki/Airship?target=_blank).
  

# Introducción a Ironic y Metal3
<div class="grav-youtube"><iframe src="https://www.youtube.com/embed/2It3XtWnLlI" frameborder="0" allowfullscreen=""></iframe></div>

