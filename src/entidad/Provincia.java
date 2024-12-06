package entidad;

public class Provincia {
	private int idProvincia;
	private String nombre;
	
	public Provincia() {
		
	}
	
	public Provincia(int idProvincia, String nombre) {
		this.idProvincia = idProvincia;
		this.nombre = nombre;
	}
	
	public int getId() {
		return idProvincia;
	}
	
	public void setId(int idProvincia) {
		this.idProvincia = idProvincia;
	}
	
	public String getNombre() {
		return nombre;
	}
	
	public void setNombre(String nombre) {
		this.nombre = nombre;
	}
}