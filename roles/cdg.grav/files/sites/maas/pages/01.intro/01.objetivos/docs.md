---
title: Objetivos
taxonomy:
    category: docs
---

# MaaS (Metal as a Service): Gestión UnderCloud 

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
+ **PASO 2: Ironic:** aprovisionamiento de máquinas físicas... introducción a la API de Ironic.
+ **PASO 3: Metal3:** despliegue de clústers con Metal3.
+ **PASO 4: Estrategias de Despliegue:** cómo gestionar un repositorio de configuraciones para integrarlas de manera orgánica, incluyendo los vitales mecanismos de herencia. Se toma como referencia el proyecto [OSM](https://osm.etsi.org/?target=_blank) de [ETSI](https://www.etsi.org/?target=_blank).

# Introducción a Ironic y Metal3
<div class="grav-youtube"><iframe src="https://www.youtube.com/embed/2It3XtWnLlI" frameborder="0" allowfullscreen=""></iframe></div>
