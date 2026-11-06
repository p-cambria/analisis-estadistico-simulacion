# Proyecto 08 | Chi-cuadrado de independencia
# Quiero revisar si el tipo de cliente se relaciona con la morosidad.
# Datos originales de la práctica. Todo está hecho en R base.

# 1. Organizo los datos: columnas = no moroso y moroso
tabla <- matrix(c(120, 30,
                  80, 40,
                  55, 35),
                nrow = 3, byrow = TRUE)
rownames(tabla) <- c("Asalariado", "Independiente", "Microempresario")
colnames(tabla) <- c("No moroso", "Moroso")
print(tabla)

# 2. Calculo el porcentaje de morosidad en cada grupo
tasa_morosidad <- tabla[, "Moroso"] / rowSums(tabla) * 100
print(round(tasa_morosidad, 2))

# 3. H0: las dos variables son independientes.
#    H1: existe asociación entre el tipo de cliente y la morosidad.
prueba <- chisq.test(tabla, correct = FALSE)
print(prueba)
cat("\nFrecuencias esperadas:\n")
print(round(prueba$expected, 2))

# 4. La intensidad de la asociación se puede resumir con V de Cramér
n <- sum(tabla)
v_cramer <- sqrt(as.numeric(prueba$statistic) / (n * min(nrow(tabla)-1, ncol(tabla)-1)))
cat("\nV de Cramér:", round(v_cramer, 3), "\n")

if (prueba$p.value < 0.05) {
  cat("Hay evidencia de asociación entre las variables.\n")
} else {
  cat("No hay evidencia suficiente de asociación.\n")
}

# 5. Gráfico de tasas de morosidad por tipo de cliente
if (!dir.exists("figuras")) dir.create("figuras")
png("figuras/tasa-morosidad.png", width = 1000, height = 650, res = 140)
barplot(tasa_morosidad, col = "#83C8C0", ylim = c(0, 48),
        main = "Morosidad observada por tipo de cliente",
        ylab = "Clientes con morosidad (%)")
dev.off()

# Encontrar una asociación no significa demostrar causalidad.
