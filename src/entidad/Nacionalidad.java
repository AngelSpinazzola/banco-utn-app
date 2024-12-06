package entidad;

public class Nacionalidad {
	private int id;
	private String nacionalidad;
	
	public Nacionalidad(int id, String nacionalidad){
		this.id = id;
		this.nacionalidad = nacionalidad;
	}
	
	public Nacionalidad(){

	}

	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

	public String getNacionalidad() {
		return nacionalidad;
	}

	public void setNacionalidad(String nacionalidad) {
		this.nacionalidad = nacionalidad;
	}
}