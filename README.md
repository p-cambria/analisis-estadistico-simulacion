# Análisis Estadístico y Simulación | Portafolio en R

En este repositorio reuní **12 ejercicios** que desarrollé durante la asignatura *Análisis Estadístico y Simulación*. Quise organizarlos de manera que cada problema tuviera su código, sus resultados y una explicación fácil de seguir.

Los casos utilizan **datos originales de las prácticas académicas**. No representan operaciones reales de bancos, empresas ni personas. Mantengo las conclusiones dentro de lo que permite cada ejercicio.

## Proyectos

| Nº | Tema | Problema |
| --- | --- | --- |
| 01 | Estadística descriptiva | [Rendimientos de un portafolio](01-estadistica-descriptiva/) |
| 02 | Intervalos de confianza | [Aprobación de créditos digitales](02-intervalos-confianza/) |
| 03 | Prueba para una proporción | [Morosidad de préstamos](03-hipotesis-proporcion/) |
| 04 | Comparación de medias | [Tecnología agrícola](04-comparacion-medias/) |
| 05 | Comparación de proporciones | [Programas de salud](05-comparacion-proporciones/) |
| 06 | Inferencia para varianzas | [Volatilidad de fondos](06-inferencia-varianzas/) |
| 07 | Chi-cuadrado: bondad de ajuste | [Distribución de riesgo crediticio](07-chi-cuadrado-bondad-ajuste/) |
| 08 | Chi-cuadrado: independencia | [Tipo de cliente y morosidad](08-chi-cuadrado-independencia/) |
| 09 | ANOVA de un factor | [Aprobación por sucursal](09-anova-un-factor/) |
| 10 | ANOVA de dos factores | [Gasto con tarjeta por edad y género](10-anova-dos-factores/) |
| 11 | Regresión lineal simple | [Publicidad y ventas](11-regresion-lineal-simple/) |
| 12 | Bootstrap | [Montos de transacciones financieras](12-bootstrap-transacciones/) |

## ¿Qué encontrarás?

Cada carpeta contiene:

- **`analisis.R`**: script sencillo y comentado, con los datos y el procedimiento estadístico.
- **`practica-resuelta.pdf`**: desarrollo breve del problema y conclusiones.
- **`README.md`**: resumen del análisis, los hallazgos y cómo reproducirlos.
- **`figuras/`**: gráficos para acompañar los resultados.

## Cómo usar los proyectos

1. Descarga o clona el repositorio.
2. Abre en RStudio la carpeta del ejercicio que te interesa y configúrala como directorio de trabajo.
3. Ejecuta `source("analisis.R")`, o abre el script y corre sus secciones.

Los scripts usan **R base**; no se necesitan paquetes adicionales. Los gráficos incluidos se prepararon para presentar el proyecto y, al ejecutar R, puedes recrearlos o actualizarlos con las instrucciones de cada script. Los resultados de Bootstrap pueden variar levemente entre generadores o versiones de R.

Este portafolio documenta mi aprendizaje. No presenta datos simulados como mediciones reales ni convierte asociaciones en causalidad.
