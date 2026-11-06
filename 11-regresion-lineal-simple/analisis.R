# Proyecto 11 | Regresión lineal simple
# Estudio la relación entre inversión en publicidad y ventas.
# Las cantidades están en miles de pesos.

# 1. Datos originales del examen final
inversion <- c(20, 25, 30, 35, 40, 45, 50, 55, 60, 65)
ventas <- c(105, 118, 128, 143, 155, 166, 181, 190, 207, 218)
datos <- data.frame(inversion, ventas)

# 2. Ajusto la regresión lineal
modelo <- lm(ventas ~ inversion, data = datos)
print(summary(modelo))

# 3. Reviso los coeficientes y el R cuadrado
coeficientes <- coef(modelo)
r_cuadrado <- summary(modelo)$r.squared
cat("\nIntercepto:", round(coeficientes[1], 4), "\n")
cat("Pendiente:", round(coeficientes[2], 4), "\n")
cat("R cuadrado:", round(r_cuadrado, 4), "\n")

# 4. Pronóstico: ¿cuánto venderíamos con 52 mil en publicidad?
pronostico <- predict(modelo, newdata = data.frame(inversion = 52))
cat("Pronóstico para inversión de 52 mil:", round(pronostico, 2),
    "mil pesos en ventas\n")

# 5. Gráfico con los datos y la recta estimada
if (!dir.exists("figuras")) dir.create("figuras")
png("figuras/regresion-publicidad-ventas.png", width = 1000, height = 650, res = 140)
plot(inversion, ventas, pch = 19, col = "#287F9E",
     main = "Inversión publicitaria y ventas",
     xlab = "Inversión (miles de pesos)",
     ylab = "Ventas (miles de pesos)")
abline(modelo, col = "#D09244", lwd = 2)
points(52, pronostico, pch = 17, col = "#D09244", cex = 1.5)
dev.off()

# Un ajuste muy alto no demuestra causalidad.
