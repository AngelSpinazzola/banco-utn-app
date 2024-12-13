package excepciones;

public class PrestamoNegocioException extends RuntimeException{
	private static final long serialVersionUID = 1L;

	public PrestamoNegocioException(String message) {
		super(message);
	}
}
