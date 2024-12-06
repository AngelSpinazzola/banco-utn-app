package entidad;

import java.sql.Date;
import entidad.Nacionalidad;


public class Cliente extends Usuario{
	private	String dni;
	private String cuil;
	private String nombre;
	private String apellido;
	private String sexo;
	private Nacionalidad nacionalidad;
	private Date fechaNacimiento;
	private Direccion direccion;
	private String email;
	private int cantidadCuentas;
	private String numeroTelefono;
	private boolean estado;
	private int idCliente;
	
	public Cliente() {
		super();
	}
	
	public Cliente(String dni, String cuil, String nombre, String apellido, String sexo, Nacionalidad nacionalidad,
			Date fechaNacimiento, Direccion direccion, String email) {
		super();
		this.dni = dni;
		this.cuil = cuil;
		this.nombre = nombre;
		this.apellido = apellido;
		this.sexo = sexo;
		this.nacionalidad = nacionalidad;
		this.fechaNacimiento = fechaNacimiento;
		this.direccion = direccion;
		this.email = email;
	}
	
	public int getIdCliente() {
		return idCliente;
	}

	public void setIdCliente(int idCliente) {
		this.idCliente = idCliente;
	}

	public String getDni() {
		return dni;
	}

	public void setDni(String dni) {
		this.dni = dni;
	}

	public String getCuil() {
		return cuil;
	}

	public void setCuil(String cuil) {
		this.cuil = cuil;
	}

	public String getNombre() {
		return nombre;
	}

	public void setNombre(String nombre) {
		this.nombre = nombre;
	}

	public String getApellido() {
		return apellido;
	}

	public void setApellido(String apellido) {
		this.apellido = apellido;
	}

	public String getSexo() {
		return sexo;
	}

	public void setSexo(String sexo) {
		this.sexo = sexo;
	}
	
	public Nacionalidad getNacionalidad() {
		return nacionalidad;
	}

	public void setNacionalidad(Nacionalidad nacionalidad) {
		this.nacionalidad = nacionalidad;
	}

	public Date getFechaNacimiento() {
		return fechaNacimiento;
	}

	public void setFechaNacimiento(Date fechaNacimiento) {
		this.fechaNacimiento = fechaNacimiento;
	}

	public Direccion getDireccion() {
		return direccion;
	}

	public void setDireccion(Direccion direccion) {
		this.direccion = direccion;
	}

	public String getEmail() {
		return email;
	}

	public void setEmail(String email) {
		this.email = email;
	}

	public int getCantidadCuentas() {
		return cantidadCuentas;
	}

	public void setCantidadCuentas(int cantidadCuentas) {
		this.cantidadCuentas = cantidadCuentas;
	}

	public String getNumeroTelefono() {
		return numeroTelefono;
	}

	public void setNumeroTelefono(String numeroTelefono) {
		this.numeroTelefono = numeroTelefono;
	}

	public boolean isEstado() {
		return estado;
	}

	public void setEstado(boolean estado) {
		this.estado = estado;
	}
}