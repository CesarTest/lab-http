---
title: Troubleshooting
taxonomy:
    category: docs
---

# TroubleShooting: Método General
## Método Científico aplicado al Troubleshooting: {Síntomas, Evidencias} – {Hallazgos y Resultados}

La imagen ilustra cómo distintas instituciones tecnológicas emplean un mismo método reproducible por cualquier persona en sus procesos de troubleshooting, estructurado en dos fases:
1. **Diagnóstico (en rojo) – Síntomas y Evidencias:** definir síntomas y recopilar evidencias para describir génesis del problema, el estado del sistema y el impacto del problema. Para esta etapa, es esencial contar con buenos sistemas de trazabilidad y monitorización.
2. **Resolución (en amarillo) – Hallazgos y Resultados:** bucle de ensayo/error verificando diferentes hipótesis sobre causas del problema. Reproducir el problema en un entorno controlado ayuda a la hora de formalizar hallazgos. Según la complejidad del entorno, esto puede implicar elaborar planes de acción y recuperación en cada iteración.

![Método Científico](image://intro/metodo.jpg)

## La Base Documental.
Dado que los problemas suelen repetirse, se torna esencial documentar los casos, y clasificarlos de manera que se reduzcan al mínimo su número. Una clasificación por causa raíz, puede simplificar esta base de datos, al ir agrupando “tema y variaciones”.
Aparecen dos documentos diferentes:
+ **Diagnóstico - Documento de Definición:** en primer paso en el diagnóstico consiste en resumir la sintomatología de manera estructurada. A continuación, se van agregando las evidencias que los protocolos de diagnóstico van localizando. La base documental de otros casos se torna parte esencial.
+ **Resolución - Documento de Resultados:** una vez resuelta la anomalía, se resume toda la información relevante del caso: a) Síntomas; b) Resolución; c) Análisis de causa raíz (opcional, pero esencial cuando hay que depurar responsabilidades).

# TroubleShooting en Linux
## Base Documental y Herramientas de Diagnóstico.
### RedHat
BASE DOCUMENTAL                 | HERRAMIENTAS DE ANÁLISIS
--------------------------------|--------------------------------------
<p><b>Documento de Definición:</b> <code>sosreport</code></p></p>[https://bugzilla.redhat.com/](https://bugzilla.redhat.com/?target=_blank)</p>| <p><b>Trazabilidad:</b><ul><li>Logs</li><li>Journal</li></ul></p><p><b>Telemetría:</b><ul><li>Audit</li></ul></p>
<p><b>Documento de Resultados:</b></p><p><u>Web RedHat:</u>[https://access.redhat.com/support/cases/#/troubleshoot/summarize](https://access.redhat.com/support/cases/#/troubleshoot/summarize?target=_blank)</p><p><u>Web Ubuntu:</u>[https://wiki.ubuntu.com/Home](https://bugzilla.redhat.com/?target=_blank)</p>| <p><b>Monitorización:</b><ul><li>Cockpit</li></ul></p>

### Indra
BASE DOCUMENTAL                 | HERRAMIENTAS DE ANÁLISIS
--------------------------------|--------------------------------------
<p><b>Documento de Definición:</b> documentación interna de cada equipo</p>| <p><b>Trazabilidad:</b><ul><li>Herramientas RHEL y Propias</li></p>
<p><b>Documento de Resultados:</b>[IBM Rational Synergy](https://www.ibm.com/es-es/products/rational-synergy?target?_blank), web privada</p>|<p><b>Monitorización:</b><ul><li>[Checkmk](https://checkmk.com/?tareget=_blank)</li><li>[Pila EFK](https://www.elastic.co/elastic-stack?target=_blank)</li><li>[Pila PLG](https://docs-bigbang.dso.mil/2.31.0/packages/monitoring/docs/prometheus-loki-grafana/?target=_blank)</li></ul></p>

## Diagnóstico: Síntomas y Evidencias.
### ETAPA 1: Definición del Problema, los Síntomas.
La primera etapa del diagnóstico consiste crear el documento de definición del problema:
+ **Descripción de la sintomatología de una forma estructurada,** delineando subsistemas afectados.
+ **(Opcional) Anatomía de los subsistemas afectados:** estructura de demonios e interacciones.
+ **(Opcional) Secuencia de eventos relevantes a este diagnóstico:** a la luz de la anatomía de los subsistemas afectados, se establece qué protocolos de diagnóstico que hay que aplicar para sondear la secuencia de eventos relevantes en este caso.  RedHat tiene la herramienta <code>sosreport</code> para reportar anomalías: recopila automáticamente información relevante del sistema operativo para facilitar los diagnósticos. 

En la tabla, un ejemplo sacado de documentación interna Indra, a modo de referencia.
![Herramientas Análisis](image://teoria/troubleshoot-definicion.jpg)

### ETAPA 2: Protocolos de Diagnóstico, Recopilando Evidencias.
La segunda etapa del diagnóstico consiste en recopilar evidencias donde las herramientas principales de análisis son trazabilidad y telemetría que permiten ver la actividad del entorno de ejecución. Journalctl supone una mejora significativa en el detalle de las trazas, respecto Rsyslog. 
+ **Se trata de aplicar los protocolos de diagnóstico establecidos en la etapa 1:** hay dos formas de aplicarlos:
  - *Pruebas en Local, Fin -> Principio:* evidencias de los últimos eventos descartan la necesidad de evidencias de los primeros.
  - *Apertura de Caso, Principio -> Fin:* el especialista que tiene que hacer el análisis tal vez no pueda reproducir el problema, solo se basa en las evidencias que recibe. Será capaz de llegar antes a una hipótesis válida si puede descartar ciertas hipótesis en base a poder reconstruir la secuencia de eventos de principio a fin. 
+ **Los protocolos de diagnóstico son automatizables,** pudiendo incorporarse como parte de los mantenimientos establecidos en normativa de calidad.
+ **Evidencias de la secuencia de eventos se agregan al Documento de Definición,** que será el punto de partida de la fase de Resolución.

En la sección diganósticos, se describe un maletín básico de herramientas de análisis para los subsistemas principales del entorno de ejecución. Se comienza cada sección con una descripción gráfica de la anatomía de cada subsistema, esencial para determinar cómo se usan las herramientas de análisis que se exponen después.

## Resolución: Hallazgos y Resultados.
### ETAPA 3 Y 4: Formalizar Hallazgos - Crear y Verificar Hipótesis.
A partir de las evidencias recopiladas en la fase de diagnóstico, comienza un bucle ensayo/error que permite llegar a una solución. En algunos casos, puede ser conveniente reproducir la anomalía en un entorno controlado y hacer ahí todos los ensayos necesarios.
EL ciclo ensayo/error sigue los siguientes tres pasos:
1. **Crear Hipótesis:** tras un análisis de las evidencias a la luz de la arquitectura del subsistema donde surge la anomalía, y la secuencia de eventos relevantes que deriva de esa arquitectura de subsistema, se formulan las primeras hipótesis.
2. **Formalizar Hallazgos:** una vez establecida una hipótesis, se formula un procedimiento de verificación, y otro de marcha atrás para no dejar el sistema en mal estado. Una hipótesis que no pueda verificarse formalizándose en hallazgo no es una hipótesis válida y ha de ser descartada.
3. **Completar Documento de Definición:** ir documentando cada hipótesis, sus procedimientos de verificación y restauración, así como los hallazgos que resultan de su comprobación. Esto permite compartir conclusiones fácilmente, y así otra persona pueda continuar la resolución de este problema.

### ETAPA 5: Resolución y Documentación de Resultados.
#### Razón de Ser de los Documentos de Resultados.
Se presentan dos documentos de resultados diferentes, enfocados a distintos públicos cada uno:
+ ** Documentos de resultados – Las métricas:** un resumen escueto que tiene dos tipos de audiencia:
  - *Auditores de Calidad:* necesitan localizar métricas que suelen estar relacionadas con tiempos de resolución y el impacto sobre la disponibilidad del sistema en su conjunto (si existen bloqueos a otros equipos y qué riesgos implican los tiempos de resolución en las planificaciones de proyecto). En conclusión, datos relevantes son:
    + Fechas de apertura y cierre de incidencia
    + Impacto en la toda la cadena de trabajo.
  - *Equipos de otras fases del desarrollo del Sistema:* necesitan conocer el estado de la incidencia en todo momento, para poder planificar sus tareas y ajustarse a los tiempos establecidos en el proyecto. Datos relevantes son:
    + El estado de la incidencia
    + Al cierre, un resumen telegráfico de síntomas y resolución.
+ **Análisis de Causa Raíz – Causas y Medidas:** mucho más exhaustivo que el documento de resultado, esta audiencia necesita establecer argumentos que solo puede articular si conoce los motivos de cada conclusión. Dos tipos de audiencia:
  - *Sistema Legal:* para delinear responsabilidades es necesario conocer el desglose pormenorizado del caso. Datos relevantes:
    + Definición del problema, síntomas y evidencias recolectadas.
    + Cronograma de actuaciones con sus responsables: hallazgos y como se llega a ellos.
    + Causa Raíz
  - *Jefe de Área:* un cambio en el diseño de producto suele implicar un coste, a veces muy elevado. A partir de varios análisis de causa raíz que señalen una misma vulnerabilidad, se puede calcular si el coste del riesgo de que se repita esta incidencia (ya sea por criticidad, ya sea por exceso de reiteración), justifica el rediseño de producto. Datos relevantes:
    + Planes de prevención del incidente.
    + Cómo se ha llegado a esa conclusión.

#### Documentos de resultados – Las métricas
+ **Ajuste a Normativa de Calidad** (ejm.: ISO/IEC 25020, SQuaRE – Framework Medición Calidad), el documento de resultados sigue una estructura estandarizada, mediante alguna herramienta especializada. Indra emplea IBM Rational Synergy. Tres son los objetivos de este documento:
 - Establecer responsabilidades.
 - Coordinar equipos de trabajo en distintas fases de desarrollo de producto.
 - Establecer métricas que permitan verificar cumplimiento de requisitos de contrato.
+ **Objetivos de una Base de Datos Anomalías:
 - Búsqueda rápida de incidencias, y sus relaciones con otras fases del proyecto y responsables.
 - Clasificación por patrones, para minimizar el tamaño de la base de datos y simplificar las búsquedas

#### Análisis de Causa Raíz – Causas y Medidas
Este documento opcional se elabora cuando existen inversiones que realizar. Por ejemplo, en el caso de un incendio provocado por el diseño de una fachada, ¿quién debe pagar la restauración? Si el constructor cumple con la normativa vigente en el momento de la construcción, es responsabilidad del ayuntamiento. Sin embargo, si el constructor no cumplía la normativa, la restauración corre por cuenta del constructor. 

Otro ejemplo, sería cuando el equipo técnico necesita un cambio en el diseño del modelo, hay que justificar el coste y los riesgos que implica las deficiencias del diseño frente al coste del cambio, esto solo se logra si sucede algo crítico aportando estos análisis, o si se reitera muchas veces, provocando retrasos e inconvenientes cuantificables que finalmente compensen el cambio.

+ **Sección Opcional del Documento de Resultados**, que permite: 
 - *Depurar Responsabilidades.*
 - *Mejora Continua,* área técnica expone planes de acción para prevenir incidentes que pueden inducir cambios en el diseño de producto, o nuevas políticas de gestión.
+ **Todo RCA debe contener los siguientes elementos:** 
1. <u>CAUSAS - Documento Definición de Problema.</u>
2. <u>CAUSAS - Hallazgos clave:</u> Línea de tiempo de eventos y acciones tomadas (análisis de Pareto).
3. <u>CAUSAS - Análisis de Objetivo-Peligro-Barrera:</u> un análisis de riesgos que determine la importancia de adoptar planes de prevención. Se buscan deficiencias o brechas del sistema que puedan requerir replantear políticas o cambios de diseño. En otras palabras, a pesar de todas las barreras (por ejemplo, duplicidades que evitan la pérdida de servicio), este informa justifica qué peligros sigue implicando esta brecha. 
4. <u>CAUSAS - Preguntas a Especialistas:</u> tal vez sea necesario acudir a distintos especialistas antes de empezar el análisis de causa-efecto, localizar la cadena de responsabilidades y motivos de cada decisión, así como retrasos y dificultades organizativas de los proyectos.
5. <u>CAUSAS - Análisis de las relaciones Causa-Efecto:</u> resumen de causas, a través del diagrama Ishikawa o el de los 5 porqué, son técnicas habituales en estos análisis, aunque existen diagramas más modernos.
6. <u>MEDIDAS - Diagrama de Resultados:</u> resumen de consecuencias (riesgos y peligros) condensar todos los análisis anteriores en un diagrama de conclusiones, que deben dar pie a planes de prevención.
7. <u>MEDIDAS - Planes de Prevención:</u> a partir de diagramas de resultados, derivar medidas para mitigar esos riesgos que pueden y suelen implicar inversiones, ya sea en aspectos organizativos, o en rediseños.
8. <u>MEDIDAS - Revisiones de Eficacia:</u> métricas sobre la eficacia de las medidas de prevención.