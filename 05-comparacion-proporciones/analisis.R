# Proyecto 05 | Comparación de dos proporciones
# ¿Los programas A y B tienen el mismo porcentaje de cumplimiento?
# Práctica de Análisis Estadístico y Simulación.
# Utilizo R base para que el código sea fácil de seguir.

# 1. Datos originales del ejercicio
# Participantes que realizaron su control preventivo anual
controles <- c(A = 185, B = 195)
participantes <- c(A = 250, B = 300)

# 2. Calculo los porcentajes y la diferencia observada
proporciones <- controles / participantes
diferencia <- proporciones["A"] - proporciones["B"]

resumen <- data.frame(
  Programa = names(controles),
  Participantes = as.numeric(participantes),
  Realizaron_control = as.numeric(controles),
  Porcentaje = round(as.numeric(proporciones) * 100, 2)
)
print(resumen)
cat("\nDiferencia (A - B):", round(diferencia * 100, 2), "puntos porcentuales\n")

# 3. Intervalo de confianza del 95 % para la diferencia
# Uso la aproximación normal con el error estándar de cada grupo.
error_estandar <- sqrt(
  proporciones["A"] * (1 - proporciones["A"]) / participantes["A"] +
  proporciones["B"] * (1 - proporciones["B"]) / participantes["B"]
)

margen <- qnorm(0.975) * error_estandar
ic <- diferencia + c(-margen, margen)
cat("\nIC del 95 % para A - B (puntos porcentuales):\n")
print(round(ic * 100, 2))

# 4. Prueba bilateral para comparar las dos proporciones
# H0: las proporciones de ambos programas son iguales.
# H1: las proporciones son diferentes.
prueba <- prop.test(controles, participantes, correct = FALSE)
cat("\nPrueba de hipótesis (sin corrección de continuidad):\n")
cat("Chi-cuadrado:", round(unname(prueba$statistic), 4), "\n")
cat("Valor p:", round(prueba$p.value, 4), "\n")

if (prueba$p.value < 0.05) {
  cat("Conclusión: encontramos evidencia de una diferencia entre ambos programas.\n")
} else {
  cat("Conclusión: no hay evidencia suficiente de una diferencia entre ambos programas.\n")
}

# 5. Gráficos sencillos para mostrar el resultado
if (!dir.exists("figuras")) dir.create("figuras")

png("figuras/cumplimiento-programas.png", width = 1000, height = 650, res = 140)
barras <- barplot(proporciones * 100,
                  col = c("#DCE7EF", "#B7DCD5"),
                  ylim = c(0, 90),
                  ylab = "Personas que realizaron el control (%)",
                  main = "Cumplimiento por programa")
text(barras, proporciones * 100 + 4,
     labels = paste0(round(proporciones * 100), "%"), cex = 1.2)
dev.off()

png("figuras/intervalo-diferencia.png", width = 1000, height = 540, res = 140)
plot(NA, xlim = c(-5, 21), ylim = c(0.5, 1.5),
     yaxt = "n", ylab = "", xlab = "Diferencia A - B (puntos porcentuales)",
     main = "Intervalo de confianza del 95 %", bty = "n")
abline(v = 0, lty = 2, col = "#B78053", lwd = 2)
segments(ic[1] * 100, 1, ic[2] * 100, 1, lwd = 7, col = "#008E91")
points(diferencia * 100, 1, pch = 19, cex = 1.5, col = "#173A50")
text(diferencia * 100, 1.17, labels = "+9 puntos", cex = 1)
dev.off()

# Un resultado estadísticamente significativo no demuestra causalidad.
# También hay que revisar la selección de participantes y la utilidad práctica.
