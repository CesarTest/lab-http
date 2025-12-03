---
title: Objetivos
taxonomy:
    category: docs
---

# MaaS (Metal as a Service): Gestión UnderCloud 

## Ciclo de Vida de Kubernetes: Cluster API 

1. **Kubernetes Cluster API** es una interfaz estándar para gestionar el ciclo de vida de clústeres kubernetes sobre cualquier tipo de infrastructura (física o virtualizada) en una modalidad GitOps que facilita su automatización.
2. **Metal3 permite a Cluster API gestionar clústeres sobre un tipo de infraestructura específica: la infraestructura física.** Para ello ofrece una interfaz estándar de CDRs (Custom Resources Definition) que se integra bien con Cluster API.
3. **Ironic es la pieza de Metal3 que gestiona las máquinas físicas durante los despliegues.** Ofrece una interfaz nativa OpenStack para hablar con el resto de componentes de OpenStack. Metal3 ha desarrollado un Baremetal Operator que adapta la interfaz que ofrece Ironic a la interfaz de CDRs que necesita Cluster API.

## El rol de Metal3 en las Fábricas OpenShift

+ **Kubernetes Cluster API es una pieza estandarizada** del propio proyecto kubernetes que aspira a gestionar todo tipo de clúster (OpenShift, OKD, Rancher, etc.) sobre cualquier infraestructura física o virtualizada.
+ **Se espera que todas las fábricas software desplieguen sus entornos de trabajo Cluster API.** 
+ **RedHat e IBM apuntan hacia una infraestructura hiperconvergente sin virtualización** donde Metal3 es componente fundamental para la gestión del ciclo de vida de los clústeres.

## Ejercicios de Automatización de Infraestructura

+ **Acelerar Formación:** el UnderCloud es mucho más complejo de lo que aparenta, requiere de una formación específica que se procura acelerar mediante estos ejercicios.
+ **Estándarés de Trabajo permite la integración de piezas:** RedHat está elaborando estándares que permiten integrar el trabajo de los distintos fabricantes. Objetivo de estos ejercicios es formalizar políticas de trabajo que pueen ser aplicadas por equipos de automatización. 

# Introducción a Ironic y Metal3
<div class="grav-youtube"><iframe src="https://www.youtube.com/embed/2It3XtWnLlI" frameborder="0" allowfullscreen=""></iframe></div>
