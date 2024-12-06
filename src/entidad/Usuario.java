package entidad;

public class Usuario {

	private int id;
	private String nombreUsuario;
	private String password = "123";
	private final TipoUsuario tipo;

	public Usuario() {
		this.nombreUsuario = "user";
		this.tipo = TipoUsuario.cliente;
	}

	public Usuario(int id, String nombreUsuario, TipoUsuario tipo) {
		this.nombreUsuario = nombreUsuario;
		this.tipo = tipo;
		this.id = id;
	}

	public String getNombreUsuario() {
		return nombreUsuario;
	}

	public void setNombreUsuario(String nombreUsuario) {
		this.nombreUsuario = nombreUsuario;
	}

	public String getPassword() {
		return password;
	}

	public void setPassword(String password) {
		this.password = password;
	}

	public int getId() {
		return id;
	}
	
	public void setId(int id) {
		this.id = id;
	}

	public TipoUsuario getTipo() {
		return tipo;
	}
}