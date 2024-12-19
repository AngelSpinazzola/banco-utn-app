package negocio;

import entidad.Usuario;

public interface IUsuarioNegocio {
	Usuario login(String email, String pass);
	public boolean validarInactivo(int idUsuario);
}