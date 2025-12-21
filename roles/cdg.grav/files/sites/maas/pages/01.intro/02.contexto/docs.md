---
title: Contexto
taxonomy:
    category: docs
---

# Ciberseguridad: Los Nuevos Estándares
 
Hasta ahora la ciberseguridad se basaba en blindar el centro de datos, al margen de lo que éste contenga. Los nuevos estándares, como [NIS2 (Network and Information Security)](https://digital-strategy.ec.europa.eu/en/policies/nis2-directive?target=_blank), centran su atención en la calidad de las aplicaciones que están ejecutándose en esos centros datos. Esto implica reestructurar la producción del software en base a dos principios:

1. **Desacoplar fábrica de operadora:** se habla de cadena de valor del software. Las operadoras siguen su tarea de blindar el entorno de ejecución, las fábricas se desentienden de estas cuestiones para poder centrarse en los problemas del diseño de aplicaciones.
2. **Calidad en la producción de aplicaciones en fábricas:** en suma, transparencia en esa cadena de valor. El foco gira hacia los procesos de fabricación de esa aplicaciones y sus ingredientes (para poder localizar sus vulnerabilidades). 

## Principio 1: Desacoplo Fábrica de Operadora

El desacoplo se logra a través de la estandrización de dos elementos: Formato de Entrega de aplicaciones y la plataforma de ejecución (que debe poder desplegarse sobre cualquier hardware, ya sea un avión, un submarino, una nube, etc.). 
Esta estructuración de la cadena de valor del software aporta una estabilidad al desarrollo de aplicaciones frente a la evolución tecnológica que se torna vital para la evolución de infraestructuras críticas.
 
[div class="table"] 
Formato Entrega|Plataforma Ejecución
---------------|---------------------
![Formato Entrega](image://intro/entrega.jpg) | ![Plataforma Ejecución](image://intro/plataforma.jpg) 
[/div]
 
## Principio 2: Calidad en la Producción de Aplicaciones 

Transparencia en los procesos de producción se logra en base dos principios:
1. **SBOM (Software Bill of Materials) en el Formato de Entrega de Aplicación:** cada pieza software que se libera al repositorio lleva su lista de ingredientes, permitiendo el control de vulnerabilidades de sus dependencias.
2. **Agilidad en Procesos de Producción:** la automatización (tanto en factoría como en operadora) permite actuar de manera rápida sobre cualquier vulnerabilidad detectada en las aplicaciones.

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
