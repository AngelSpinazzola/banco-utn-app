package dao;

import entidad.Usuario;

public interface IUsuarioDao {
	Usuario Loguear(String nombre_usuario, String pass);
	public boolean validarInactivo(int idUsuario);
}