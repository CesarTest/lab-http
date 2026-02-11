---
title: Contexto
taxonomy:
    category: docs
---

# Ciberseguridad: Los Nuevos Estándares
 
Hasta ahora la ciberseguridad se basaba en blindar el centro de datos, al margen de lo que éste contenga. Los nuevos estándares, como [NIS2 (Network and Information Security)](https://digital-strategy.ec.europa.eu/en/policies/nis2-directive?target=_blank), centran su atención la cadnea de valor del software para garantizar estandares de calidad de las aplicaciones que están ejecutándose en esos centros datos. 

## Cadena de Valor del Software
![Cadena Valor Software](image://intro/cadena.jpg)

### Fábricas: Endor Labs
La plataforma Endor Labs ayuda a controlar los tres elementos de la imagen:
<div class="grav-youtube"><iframe src="https://www.youtube.com/embed/ONOocXyG7eM" frameborder="0" allowfullscreen=""></iframe></div>

### Distribución: Iron Bank
El repositorio [Iron Bank](https://p1.dso.mil/iron-bank?target=_blank)  homologa y distribuye código de manera centralizada.
![Formato Entrega](image://intro/entrega.jpg)


### Consumidor: Platform One
[Platform One](https://p1.dso.mil/?target=_blank) es una plataforma de ejecución de eaplicación agnóstica del hardware físico (un avión, un barco, un submarino, una nube, etc.).
![Plataforma Ejecución](image://intro/plataforma.jpg) 

## Ecosistema de Fábricas Software
El resultado final es un ecosistema de fábricas que trabajan de manera coordinada para suministrar las piezas necesarias que hay que ensamblar en la producción de sistemas finales (planos de control de distintas infraestructuras críticas). 
![Ecosistema](image://intro/ecosistema.jpg) 



# Automatización: La Gestión de Herramientas

Esta página aspira a acelerar los proceso de formación en automatización, cuyo resultado es la capacitación para crear y gestionar dos repositorios:

+ **Repositorio de Aplicación:** se almacenan las aplicaciones en forma de contenedores. Los contenedores se crean a través de un proceso de homologación  y securización  a partir de un repositorio de código fuente. Estas aplicaciones se desplegarán en plataformas Zero-Trust, que son clústeres kubernetes (por ejemplo, RedHat OpenShift) ya inicializados con herramientas de monitorización continua, aprovisionamiento e identificación de usuarios. 
+ **Repositorio de Estrategias de Despliegue:** colecciones de documentos YAML que definen todas las configuraciones necesarias para desplegar cada centro de datos de manera totalmente automatizada. Estas estrategias tienen tres elementos:
 - <u>Descripción de la Infraestructura o UnderCloud:</u> ejm., sectorización en clústeres k8s para controlar el ciclo de vida de aplicaciones Helm, como Helm OpenStack. Las herramientas para resolver este problema están en el mundo de la [Telco Cloud](https://osm-download.etsi.org/ftp/osm-7.0-seven/OSM9-hackfest/presentations/OSM%239%20Hackfest%20-%20HD0.0%20Introduction%20to%20NFV%20and%20OSM.pptx.pdf?target=_blank).
 - <u><a href="https://youtu.be/rfufvM3ktYE?t=1047s" target=_blank>Descripción de Entornos de Ejecución:</a></u> ejm., inicialización de clústeres con las herramientas necesarias en cada etapa de un pipeline DevSecOps. [BigBang](https://p1.dso.mil/bigbang?target=_blank) de Defensa USA sería una de las herramientas para resolver este problema. 
 - <u>Configuraciones de cada Entorno de Ejecución:</u> ejm., personalizar cada entorno de trabajo de una factoría Software.

[div class="table"] 
Sistema de Repositorios|
-----------------------|
![Formato Entrega](image://intro/repos.jpg) | 
