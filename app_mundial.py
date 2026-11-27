import tkinter as tk
from tkinter import filedialog, messagebox, ttk
import pyodbc

SERVIDOR = r"localhost\SQLEXPRESS"
BASE = "DB_Mundial_2026"
SP_XML = "torneo.SP_Reporte_SeleccionesYPlantillas_XML"

def conectar():
    cadena = (
        "DRIVER={ODBC Driver 17 for SQL Server};"
        f"SERVER={SERVIDOR};"
        f"DATABASE={BASE};"
        "Trusted_Connection=yes;"
    )
    return pyodbc.connect(cadena, autocommit=True)

def listar_idiomas():
    tabla.delete(*tabla.get_children())
    cn = conectar()
    cur = cn.cursor()
    cur.execute("SELECT IdiomaID, Nombre FROM torneo.Idioma ORDER BY IdiomaID")
    for fila in cur.fetchall():
        tabla.insert("", "end", values=(fila.IdiomaID, fila.Nombre))
    cn.close()

def agregar_idioma():
    nombre = entrada_nombre.get()
    try:
        cn = conectar()
        cn.cursor().execute("EXEC torneo.SP_Alta_Idioma @nombre = ?", nombre)
        cn.close()
        messagebox.showinfo("Listo", "Idioma agregado.")
        listar_idiomas()
    except Exception as err:
        messagebox.showerror("Error", str(err))

def editar_idioma():
    idioma_id = entrada_id.get().strip()
    nombre = entrada_nombre.get()
    try:
        cn = conectar()
        cn.cursor().execute(
            "EXEC torneo.SP_Modificacion_Idioma @IdiomaID = ?, @nombre = ?",
            int(idioma_id),
            nombre,
        )
        cn.close()
        messagebox.showinfo("Listo", "Idioma modificado.")
        listar_idiomas()
    except Exception as err:
        messagebox.showerror("Error", str(err))

def borrar_idioma():
    idioma_id = entrada_id.get().strip()
    try:
        cn = conectar()
        cn.cursor().execute("EXEC torneo.SP_Baja_Idioma @IdiomaID = ?", int(idioma_id))
        cn.close()
        messagebox.showinfo("Listo", "Idioma eliminado.")
        listar_idiomas()
    except Exception as err:
        messagebox.showerror("Error", str(err))

def elegir_fila(evento):
    sel = tabla.selection()
    if sel:
        valores = tabla.item(sel[0], "values")
        entrada_id.delete(0, "end")
        entrada_id.insert(0, valores[0])
        entrada_nombre.delete(0, "end")
        entrada_nombre.insert(0, valores[1])

def buscar_archivo():
    ruta = filedialog.askopenfilename(filetypes=[("CSV y XML", "*.csv *.xml")])
    if ruta:
        entrada_archivo.delete(0, "end")
        entrada_archivo.insert(0, ruta)

def importar_archivo():
    ruta = entrada_archivo.get().strip()
    opcion = combo_import.get()
    if opcion == "Arbitros CSV":
        sp = "reglamento.SP_ImportarArbitros_CSV"
    elif opcion == "Jugadores CSV":
        sp = "torneo.SP_ImportarJugadores_CSV"
    else:
        sp = "torneo.SP_ImportarFixture_XML"

    try:
        cn = conectar()
        cur = cn.cursor()
        cur.execute(f"EXEC {sp} @RutaArchivo = ?", ruta)
        cn.close()
        messagebox.showinfo("Listo", f"Se ejecutó {sp}.")
    except Exception as err:
        messagebox.showerror("Error", str(err))

def generar_y_guardar_xml():
    try:
        cn = conectar()
        cur = cn.cursor()
        cur.execute(f"EXEC {SP_XML}")
        filas = cur.fetchall()
        cn.close()

        texto_xml = "\n".join(str(f[0]) for f in filas if f[0] is not None)
        cuadro_xml.delete("1.0", "end")
        cuadro_xml.insert("1.0", texto_xml)

        with open("reporte_mundial.xml", "w", encoding="utf-8") as archivo:
            archivo.write(texto_xml)

        messagebox.showinfo("Listo", "XML generado y guardado como reporte_mundial.xml")
    except Exception as err:
        messagebox.showerror("Error", str(err))

ventana = tk.Tk()
ventana.title("Mundial 2026 - ABM e Importación")
ventana.geometry("760x580")

tk.Label(ventana, text="ABM Idioma (ID / Nombre):").pack(anchor="w", padx=10, pady=(8, 0))
fila_form = tk.Frame(ventana)
fila_form.pack(fill="x", padx=10)

entrada_id = tk.Entry(fila_form, width=8)
entrada_id.pack(side="left", padx=(0, 6))
entrada_nombre = tk.Entry(fila_form, width=25)
entrada_nombre.pack(side="left", padx=(0, 6))

tk.Button(fila_form, text="Alta", command=agregar_idioma).pack(side="left", padx=2)
tk.Button(fila_form, text="Modificar", command=editar_idioma).pack(side="left", padx=2)
tk.Button(fila_form, text="Baja", command=borrar_idioma).pack(side="left", padx=2)
tk.Button(fila_form, text="Actualizar", command=listar_idiomas).pack(side="left", padx=2)

tabla = ttk.Treeview(ventana, columns=("ID", "Nombre"), show="headings", height=6)
tabla.heading("ID", text="ID")
tabla.heading("Nombre", text="Nombre")
tabla.column("ID", width=60)
tabla.column("Nombre", width=220)
tabla.pack(fill="x", padx=10, pady=6)
tabla.bind("<<TreeviewSelect>>", elegir_fila)

tk.Label(ventana, text="Importación de archivo:").pack(anchor="w", padx=10, pady=(6, 0))
fila_imp = tk.Frame(ventana)
fila_imp.pack(fill="x", padx=10)

combo_import = ttk.Combobox(
    fila_imp, values=["Arbitros CSV", "Jugadores CSV", "Fixture XML"], state="readonly", width=18
)
combo_import.current(0)
combo_import.pack(side="left", padx=(0, 6))

entrada_archivo = tk.Entry(fila_imp, width=42)
entrada_archivo.pack(side="left", padx=(0, 6))
tk.Button(fila_imp, text="Elegir", command=buscar_archivo).pack(side="left", padx=2)
tk.Button(fila_imp, text="Importar", command=importar_archivo).pack(side="left", padx=2)

tk.Button(ventana, text="Generar y guardar XML", command=generar_y_guardar_xml).pack(
    anchor="w", padx=10, pady=8
)

cuadro_xml = tk.Text(ventana, height=12)
cuadro_xml.pack(fill="both", expand=True, padx=10, pady=(0, 10))

listar_idiomas()
ventana.mainloop()