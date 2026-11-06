# Proyecto 07 | Prueba chi-cuadrado de bondad de ajuste
# Análisis Estadístico y Simulación
# Quiero revisar si la distribución de riesgo de los créditos cambió
# con respecto a las proporciones históricas del ejercicio.

# 1. Datos originales de la práctica
riesgo <- c("Bajo", "Medio", "Alto")
observados <- c(88, 67, 45)
proporcion_historica <- c(0.50, 0.30, 0.20)

# 2. Calculo las frecuencias que esperaríamos según el histórico
n <- sum(observados)
esperados <- n * proporcion_historica
proporcion_actual <- observados / n

resumen <- data.frame(
  Riesgo = riesgo,
  Observados = observados,
  Esperados = esperados,
  Historico_pct = 100 * proporcion_historica,
  Actual_pct = 100 * proporcion_actual
)
print(resumen, row.names = FALSE)

# 3. Prueba chi-cuadrado de bondad de ajuste
# H0: las proporciones siguen siendo 50 %, 30 % y 20 %.
# H1: al menos una proporción poblacional es diferente.
prueba <- chisq.test(x = observados, p = proporcion_historica)

cat("\nResultados de la prueba chi-cuadrado:\n")
cat("Chi-cuadrado:", round(unname(prueba$statistic), 4), "\n")
cat("Grados de libertad:", unname(prueba$parameter), "\n")
cat("Valor p:", round(prueba$p.value, 4), "\n")

# 4. Reviso cuánto aporta cada categoría al resultado
aporte <- (observados - esperados)^2 / esperados
resumen$Aporte_chi2 <- round(aporte, 4)
cat("\nDetalle de cada categoría:\n")
print(resumen, row.names = FALSE)

# 5. Tomo una decisión con un nivel de significancia del 5 %
alpha <- 0.05
if (prueba$p.value < alpha) {
  cat("\nHay evidencia de un cambio en la distribución del riesgo.\n")
} else {
  cat("\nNo hay evidencia suficiente para afirmar que cambió la distribución.\n")
}

# 6. Gráfico sencillo para visualizar las proporciones
if (!dir.exists("figuras")) dir.create("figuras")

png("figuras/distribucion-riesgo.png", width = 1000, height = 650, res = 140)
valores <- rbind(100 * proporcion_historica, 100 * proporcion_actual)
colnames(valores) <- riesgo
barras <- barplot(valores, beside = TRUE,
                  col = c("#DCE7EF", "#77BFB6"), ylim = c(0, 58),
                  main = "Distribución del riesgo crediticio",
                  ylab = "Porcentaje de solicitudes", xlab = "Nivel de riesgo")
text(barras, as.vector(valores) + 2, labels = paste0(as.vector(valores), "%"),
     cex = 0.9)
legend("topright", legend = c("Histórico", "Observado"),
       fill = c("#DCE7EF", "#77BFB6"), bty = "n")
dev.off()

# Conclusión: las diferencias observadas no resultaron significativas al 5 %.
# Eso no demuestra que la distribución sea idéntica a la histórica.
