transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+C:/Users/aidan/OneDrive/Documents/UW-aidan-studio2/Notes/2024-2025/Autumn/EE371/Labs/Lab\ 2 {C:/Users/aidan/OneDrive/Documents/UW-aidan-studio2/Notes/2024-2025/Autumn/EE371/Labs/Lab 2/ram32x4.v}
vlog -sv -work work +incdir+C:/Users/aidan/OneDrive/Documents/UW-aidan-studio2/Notes/2024-2025/Autumn/EE371/Labs/Lab\ 2 {C:/Users/aidan/OneDrive/Documents/UW-aidan-studio2/Notes/2024-2025/Autumn/EE371/Labs/Lab 2/Lab2Task2.sv}
vlog -sv -work work +incdir+C:/Users/aidan/OneDrive/Documents/UW-aidan-studio2/Notes/2024-2025/Autumn/EE371/Labs/Lab\ 2 {C:/Users/aidan/OneDrive/Documents/UW-aidan-studio2/Notes/2024-2025/Autumn/EE371/Labs/Lab 2/seg7.sv}
vlog -sv -work work +incdir+C:/Users/aidan/OneDrive/Documents/UW-aidan-studio2/Notes/2024-2025/Autumn/EE371/Labs/Lab\ 2 {C:/Users/aidan/OneDrive/Documents/UW-aidan-studio2/Notes/2024-2025/Autumn/EE371/Labs/Lab 2/counter.sv}
vlog -sv -work work +incdir+C:/Users/aidan/OneDrive/Documents/UW-aidan-studio2/Notes/2024-2025/Autumn/EE371/Labs/Lab\ 2 {C:/Users/aidan/OneDrive/Documents/UW-aidan-studio2/Notes/2024-2025/Autumn/EE371/Labs/Lab 2/clock_divider.sv}

