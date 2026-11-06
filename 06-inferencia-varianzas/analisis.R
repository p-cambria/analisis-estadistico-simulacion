# Proyecto 06 | Comparación de volatilidad entre dos fondos
# Práctica de Análisis Estadístico y Simulación
# Quiero saber cuál fondo tiene rendimientos más variables.
# Los rendimientos están expresados en porcentajes mensuales.

# 1. Datos originales de la práctica (20 meses por fondo)
fondo_A <- c(2.1, 3.4, 1.8, 4.2, 2.7, 3.1, 2.5, 4.5, 1.6, 3.8,
             2.9, 3.3, 2.2, 4.0, 1.9, 3.6, 2.4, 4.3, 2.8, 3.0)

fondo_B <- c(1.2, 4.8, 2.0, 5.1, 1.5, 4.4, 2.2, 5.3, 1.3, 4.7,
             2.1, 5.0, 1.7, 4.5, 1.4, 4.9, 2.3, 5.2, 1.6, 4.6)

# 2. Primero reviso el promedio y la variabilidad de cada fondo
resumen <- data.frame(
  Fondo = c("A", "B"),
  Meses = c(length(fondo_A), length(fondo_B)),
  Promedio = c(mean(fondo_A), mean(fondo_B)),
  Desv_estandar = c(sd(fondo_A), sd(fondo_B)),
  Varianza = c(var(fondo_A), var(fondo_B))
)
resumen[, 3:5] <- round(resumen[, 3:5], 4)
print(resumen, row.names = FALSE)
cat("Fondo B / Fondo A (razón de varianzas):",
    round(var(fondo_B) / var(fondo_A), 4), "\n")

# 3. Intervalo de confianza del 95% para la desviación estándar de A
# Uso chi-cuadrado, que exige normalidad de los rendimientos.
n <- length(fondo_A)
alpha <- 0.05
var_A <- var(fondo_A)

limite_inferior <- sqrt((n - 1) * var_A / qchisq(1 - alpha / 2, n - 1))
limite_superior <- sqrt((n - 1) * var_A / qchisq(alpha / 2, n - 1))

cat("\nIC clásico del 95% para la desviación estándar de A:\n")
print(round(c(limite_inferior, limite_superior), 4))

# 4. Bootstrap para la desviación estándar de A
# Repito el muestreo 1,000 veces, tomando valores con reemplazo.
set.seed(123)
repeticiones <- 1000
sd_boot <- replicate(repeticiones, sd(sample(fondo_A, n, replace = TRUE)))
ic_boot <- quantile(sd_boot, c(0.025, 0.975))
cat("\nIC Bootstrap del 95% para la desviación estándar de A:\n")
print(round(ic_boot, 4))

# 5. Prueba F bilateral: ¿las varianzas poblacionales son distintas?
# H0: ambas varianzas son iguales.
# H1: las varianzas son diferentes.
prueba_F <- var.test(fondo_A, fondo_B, alternative = "two.sided")
cat("\nPrueba F de igualdad de varianzas:\n")
cat("F:", round(unname(prueba_F$statistic), 4), "\n")
cat("Valor p:", round(prueba_F$p.value, 4), "\n")

# 6. Reviso los supuestos antes de interpretar la prueba F
cat("\nNormalidad de A - valor p:", round(shapiro.test(fondo_A)$p.value, 4), "\n")
cat("Normalidad de B - valor p:", round(shapiro.test(fondo_B)$p.value, 4), "\n")

# Como B se aparta de la normalidad, agrego una prueba más robusta.
datos <- data.frame(
  rendimiento = c(fondo_A, fondo_B),
  fondo = factor(rep(c("A", "B"), each = 20))
)
prueba_robusta <- fligner.test(rendimiento ~ fondo, data = datos)
cat("Fligner-Killeen - valor p:", round(prueba_robusta$p.value, 6), "\n")

# 7. Dejo dos gráficos para explicar mejor la comparación
if (!dir.exists("figuras")) dir.create("figuras")

png("figuras/dispersion-fondos.png", width = 950, height = 600, res = 130)
boxplot(rendimiento ~ fondo, data = datos,
        main = "Variación de los rendimientos mensuales",
        xlab = "Fondo", ylab = "Rendimiento mensual (%)",
        col = c("#DCE7EF", "#B7DCD5"))
dev.off()

png("figuras/bootstrap-desviacion.png", width = 950, height = 600, res = 130)
hist(sd_boot, breaks = 20, col = "#B7DCD5", border = "white",
     main = "Bootstrap: desviación estándar del fondo A",
     xlab = "Desviación estándar (puntos porcentuales)")
abline(v = sd(fondo_A), col = "#173A50", lwd = 3)
abline(v = ic_boot, col = "#008E91", lty = 2, lwd = 2)
dev.off()

# Conclusión: B varía más que A en esta muestra.
# La prueba F clásica se interpreta con cuidado porque B no parece normal.
