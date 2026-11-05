# PROYECTO 02 | Intervalos de confianza y prueba t para una media
# Asignatura: Análisis Estadístico y Simulación
# Caso académico: tiempo de aprobación de solicitudes de crédito digital
# El enunciado ofrece estadísticos resumidos, no los 16 tiempos individuales.
# Ejecutar desde 02-intervalos-confianza/ en RStudio. Solo requiere R base.

# 1. Datos originales del enunciado
n <- 16
media_muestral <- 47.5       # minutos
s_muestral <- 8.4           # minutos
media_referencia <- 45      # minutos
alpha <- 0.05
confianza <- 1 - alpha

stopifnot(n > 1, s_muestral > 0, 0 < alpha, alpha < 1)

# 2. Intervalo de confianza clásico para la media
# Como sigma poblacional es desconocida, usamos t de Student (15 gl).
gl <- n - 1
error_estandar <- s_muestral / sqrt(n)
t_critico <- qt(1 - alpha / 2, df = gl)
limite_inferior <- media_muestral - t_critico * error_estandar
limite_superior <- media_muestral + t_critico * error_estandar

# 3. Prueba de hipótesis bilateral
# H0: mu = 45 minutos. H1: mu != 45 minutos.
t_observado <- (media_muestral - media_referencia) / error_estandar
p_valor <- 2 * pt(-abs(t_observado), df = gl)
rechazar_h0 <- p_valor < alpha

# 4. Escenario HIPOTÉTICO para comprender el tamaño de muestra
# No son datos observados: se mantienen iguales la media y la desviación.
n_simulado <- 200
gl_simulado <- n_simulado - 1
se_simulado <- s_muestral / sqrt(n_simulado)
t_critico_simulado <- qt(1 - alpha / 2, df = gl_simulado)
li_simulado <- media_muestral - t_critico_simulado * se_simulado
ls_simulado <- media_muestral + t_critico_simulado * se_simulado
t_simulado <- (media_muestral - media_referencia) / se_simulado
p_simulado <- 2 * pt(-abs(t_simulado), df = gl_simulado)

# 5. Resultados
cat("\nPROYECTO 02 | TIEMPOS DE APROBACIÓN DE CRÉDITOS DIGITALES\n")
cat(sprintf("n = %d, media = %.1f min, s = %.1f min\n", n, media_muestral, s_muestral))
cat(sprintf("Error estándar: %.4f minutos\n", error_estandar))
cat(sprintf("IC del %.0f%% para mu: [%.4f, %.4f] minutos\n",
            confianza * 100, limite_inferior, limite_superior))
cat(sprintf("Prueba bilateral: t(%d) = %.4f; valor p = %.5f\n",
            gl, t_observado, p_valor))
cat(if (rechazar_h0) "Decisión: rechazar H0.\n" else "Decisión: no rechazar H0.\n")
cat(sprintf("HIPOTÉTICO n = %d: IC [%.4f, %.4f]; valor p = %.6f\n",
            n_simulado, li_simulado, ls_simulado, p_simulado))
cat("Con los 16 casos, no hay evidencia suficiente de que la media ",
    "difiera de 45 minutos. No rechazar H0 no prueba igualdad.\n", sep = "")
cat("Precaución: con estadísticos resumidos no podemos revisar ",
    "la normalidad ni los valores atípicos de los datos originales.\n", sep = "")

# 6. Gráfico comparativo de intervalos de confianza (en PNG)
if (!dir.exists("figuras")) dir.create("figuras")
png("figuras/intervalos-confianza.png", width = 1600, height = 690, res = 160)
par(mar = c(5, 11, 2, 3), family = "sans")
plot(NA, xlim = c(42.2, 53.2), ylim = c(0.65, 2.35),
     xlab = "Tiempo promedio de aprobación (minutos)", ylab = "",
     axes = FALSE, frame.plot = FALSE)
abline(v = seq(42, 53, 1), col = "#E8EEF1", lty = 1)
abline(v = media_referencia, col = "#D38B45", lwd = 3, lty = 2)
segments(limite_inferior, 2, limite_superior, 2,
         lwd = 7, col = "#008E91", lend = "round")
points(media_muestral, 2, pch = 19, col = "#173A52", cex = 1.9)
segments(li_simulado, 1, ls_simulado, 1,
         lwd = 7, col = "#8BB6C2", lend = "round")
points(media_muestral, 1, pch = 19, col = "#173A52", cex = 1.9)
axis(1, at = 43:53, col.axis = "#466174", col = "#CBD6DC")
axis(2, at = c(2, 1), labels = c("Muestra original (n=16)",
                                "Escenario hipotético (n=200)"),
     tick = FALSE, las = 1, col.axis = "#173A52")
legend("topright", legend = c("Media muestral", "Referencia: 45 min"),
       col = c("#173A52", "#D38B45"), pch = c(19, NA),
       lty = c(0, 2), lwd = c(NA, 3), bty = "n", cex = 0.8)
dev.off()

# Verificación de consistencia numérica del problema original
stopifnot(abs(limite_inferior - 43.02395595) < 1e-6,
          abs(limite_superior - 51.97604405) < 1e-6,
          abs(p_valor - 0.25235928) < 1e-6)
