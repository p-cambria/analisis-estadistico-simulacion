# Proyecto 09 | ANOVA de un factor
# Quiero comparar los tiempos de aprobación de cuatro sucursales.
# Los datos son de una práctica académica.

# 1. Registro las siete solicitudes por sucursal
sucursal_a <- c(30, 28, 32, 29, 31, 33, 27)
sucursal_b <- c(26, 24, 25, 27, 23, 26, 24)
sucursal_c <- c(21, 23, 20, 22, 19, 24, 21)
sucursal_d <- c(28, 27, 25, 29, 26, 30, 27)

datos <- data.frame(
  sucursal = factor(rep(c("A", "B", "C", "D"), each = 7)),
  horas = c(sucursal_a, sucursal_b, sucursal_c, sucursal_d)
)

# 2. Empiezo revisando promedios y desviaciones
print(aggregate(horas ~ sucursal, datos, mean))
print(aggregate(horas ~ sucursal, datos, sd))

# 3. H0: todas las sucursales tienen el mismo promedio.
#    H1: al menos una tiene un promedio diferente.
modelo <- aov(horas ~ sucursal, data = datos)
print(summary(modelo))

# 4. Reviso supuestos: residuos y variabilidad por grupo
print(shapiro.test(residuals(modelo)))
print(bartlett.test(horas ~ sucursal, data = datos))

# 5. Con Tukey identifico entre cuáles sucursales hay diferencias
print(TukeyHSD(modelo))

# 6. Gráfico de los tiempos de aprobación
if (!dir.exists("figuras")) dir.create("figuras")
png("figuras/tiempos-sucursales.png", width = 1000, height = 650, res = 140)
boxplot(horas ~ sucursal, data = datos, col = "#B9E0DA",
        main = "Tiempo de aprobación por sucursal",
        xlab = "Sucursal", ylab = "Horas")
dev.off()

# Una aprobación más rápida no garantiza por sí sola mejor servicio.
