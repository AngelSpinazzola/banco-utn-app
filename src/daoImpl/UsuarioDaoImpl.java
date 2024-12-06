package daoImpl;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Connection;
import dao.IUsuarioDao;
import entidad.TipoUsuario;
import entidad.Usuario;

public class UsuarioDaoImpl implements IUsuarioDao {

	private static UsuarioDaoImpl instancia = null;

	public static UsuarioDaoImpl ObtenerInstancia() {
		if (instancia == null) {
			instancia = new UsuarioDaoImpl();
		}
		return instancia;
	}

	@Override
	public Usuario Loguear(String username, String contraseña) {
		String login = "select u.IDUsuario as idUsuario, u.Usuario as usuario, u.TipoUsuario as tipoUsuario from usuarios u where u.Usuario = ? AND u.Contrasenia = ?";
		Usuario usuario = null;

		try (Connection conexion = Conexion.getConnection();
				PreparedStatement statement = conexion.prepareStatement(login)) {

			statement.setString(1, username);
			statement.setString(2, contraseña);

			try (ResultSet rs = statement.executeQuery()) {
				if (rs.next()) {
					String nombre = rs.getString("Usuario");
					int tipoCodigo = rs.getInt("TipoUsuario");
					int idUsuario = rs.getInt("idUsuario");

					TipoUsuario tipo = null;
					switch (tipoCodigo) {
					case 1:
						tipo = TipoUsuario.admin;
						break;
					case 2:
						tipo = TipoUsuario.cliente;
						break;
					}

					usuario = new Usuario(idUsuario, nombre, tipo);
				}
			}
		} catch (SQLException e) {
			System.err.println("Error al intentar loguear al usuario: " + e.getMessage());
		}

		return usuario;
	}

}