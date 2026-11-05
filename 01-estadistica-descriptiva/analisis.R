# Proyecto 01 | Estadística descriptiva
# Análisis de rendimientos mensuales de un portafolio de inversión
# Asignatura: Análisis Estadístico y Simulación
# Datos originales del ejercicio académico (20 observaciones).
# Ejecutar desde la carpeta 01-estadistica-descriptiva/ en RStudio.
# No requiere instalar paquetes adicionales.

# 1. Datos del ejercicio (porcentaje mensual)
rendimientos <- c(
  1.8, 2.6, 1.2, 3.1, 2.4,
  1.5, 2.9, 2.1, 3.4, 1.7,
  2.5, 2.0, 2.8, 1.4, 3.0,
  2.3, 1.9, 3.2, 2.7, 1.6
)
referencia <- 2.0
stopifnot(length(rendimientos) == 20, all(!is.na(rendimientos)))

# 2. Estadísticos descriptivos
n <- length(rendimientos)
promedio <- mean(rendimientos)
mediana <- median(rendimientos)
desviacion <- sd(rendimientos)  # Desviación estándar muestral (n - 1)
cuartiles <- quantile(rendimientos, probs = c(0.25, 0.75))
minimo <- min(rendimientos)
maximo <- max(rendimientos)
rango <- maximo - minimo
coeficiente_variacion <- 100 * desviacion / promedio
por_encima_referencia <- sum(rendimientos > referencia)

resultados <- data.frame(
  Indicador = c("Observaciones", "Media (%)", "Mediana (%)",
                "Desviación estándar (p.p.)", "Mínimo (%)", "Máximo (%)",
                "Q1 (%)", "Q3 (%)", "Rango (p.p.)",
                "Coeficiente de variación (%)", "Meses sobre 2%"),
  Valor = c(n, promedio, mediana, desviacion, minimo, maximo,
            cuartiles[1], cuartiles[2], rango,
            coeficiente_variacion, por_encima_referencia),
  row.names = NULL
)
print(transform(resultados, Valor = round(Valor, 3)), row.names = FALSE)

# 3. Gráficos: se guardan en la carpeta figuras/
if (!dir.exists("figuras")) dir.create("figuras")

png("figuras/histograma.png", width = 1600, height = 740, res = 160)
par(mar = c(5, 5, 2, 2))
hist(rendimientos,
     breaks = seq(1.0, 3.8, by = 0.4),
     col = "#72C8CA", border = "white",
     main = "", xlab = "Rendimiento mensual (%)",
     ylab = "Frecuencia (meses)")
abline(v = promedio, col = "#18354A", lwd = 3)
abline(v = referencia, col = "#CF8A3D", lwd = 2, lty = 2)
legend("topright", legend = c("Media muestral", "Referencia histórica"),
       col = c("#18354A", "#CF8A3D"),
       lty = c(1, 2), lwd = c(3, 2), bty = "n")
dev.off()

png("figuras/boxplot.png", width = 1600, height = 540, res = 160)
par(mar = c(5, 3, 2, 2))
boxplot(rendimientos, horizontal = TRUE, col = "#BBE8E7",
        border = "#008E91", main = "",
        xlab = "Rendimiento mensual (%)")
abline(v = referencia, col = "#CF8A3D", lty = 2, lwd = 2)
dev.off()

# 4. Interpretación para el ejercicio
cat("\nCONCLUSIÓN\n")
cat(sprintf("El rendimiento promedio de los 20 meses fue %.2f%%, ", promedio))
cat(sprintf("%.2f puntos porcentuales sobre la referencia de %.2f%%.\n",
            promedio - referencia, referencia))
cat(sprintf("Los valores oscilaron entre %.1f%% y %.1f%%; ", minimo, maximo))
cat(sprintf("la desviación estándar muestral fue de %.2f puntos porcentuales.\n", desviacion))
cat(sprintf("En %d de los %d meses el rendimiento superó el %.1f%%.\n",
            por_encima_referencia, n, referencia))
cat("Estos son resultados descriptivos: por sí solos no demuestran ",
    "que la media poblacional supere la referencia.\n", sep = "")
