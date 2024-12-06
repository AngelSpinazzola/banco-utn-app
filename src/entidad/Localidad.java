package entidad;

public class Localidad {
	private int idLocalidad;
	private String nombre;
	
	public Localidad() {
		
	}
	
	public Localidad(int idLocalidad, String nombre){
		this.idLocalidad = idLocalidad;
		this.nombre = nombre;
	}
	
	public int getId() {
		return idLocalidad;
	}
	
	public void setId(int idLocalidad) {
		this.idLocalidad = idLocalidad;
	}
	
	public String getNombre() {
		return nombre;
	}
	
	public void setNombre(String nombre) {
		this.nombre = nombre;
	}
}