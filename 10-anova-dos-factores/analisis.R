# Proyecto 10 | ANOVA de dos factores
# Analizo el gasto con tarjeta según edad y género.
# Gasto mensual expresado en miles de pesos.

# 1. Datos originales de la práctica (cinco personas por combinación)
gasto <- c(
  32, 35, 34, 38, 36, 28, 30, 31, 29, 32,
  42, 45, 44, 46, 43, 38, 41, 40, 43, 39,
  37, 39, 36, 40, 38, 35, 34, 37, 36, 38
)
edad <- factor(rep(c("18-29", "30-49", "50-65"), each = 10),
               levels = c("18-29", "30-49", "50-65"))
genero <- factor(rep(rep(c("Mujeres", "Hombres"), each = 5), times = 3))
datos <- data.frame(edad, genero, gasto)

# 2. Reviso el promedio de cada combinación
print(aggregate(gasto ~ edad + genero, data = datos, mean))

# 3. Modelo con interacción entre edad y género
# Primero reviso la interacción; después los efectos principales.
modelo <- aov(gasto ~ edad * genero, data = datos)
print(summary(modelo))

# 4. Revisión básica de los supuestos
print(shapiro.test(residuals(modelo)))
print(bartlett.test(gasto ~ interaction(edad, genero), data = datos))

# 5. Comparaciones por edad (si interesa identificar los pares)
print(TukeyHSD(modelo, which = "edad"))

# 6. Gráfico de interacción
if (!dir.exists("figuras")) dir.create("figuras")
png("figuras/interaccion-edad-genero.png", width = 1000, height = 650, res = 140)
interaction.plot(x.factor = datos$edad, trace.factor = datos$genero,
                 response = datos$gasto, type = "b", pch = c(16, 17),
                 col = c("#287F9E", "#D09244"),
                 xlab = "Grupo de edad", ylab = "Gasto promedio (miles de pesos)",
                 main = "Gasto mensual por edad y género", trace.label = "Género")
dev.off()

# La interacción no resultó significativa en este ejercicio.
# No debo confundir las diferencias observadas con efectos causales.
