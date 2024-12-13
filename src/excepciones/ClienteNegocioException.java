package excepciones;

public class ClienteNegocioException extends RuntimeException{
	private static final long serialVersionUID = 1L;

	public ClienteNegocioException(String message) {
		super(message);
	}

}