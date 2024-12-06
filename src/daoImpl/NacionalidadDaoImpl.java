package daoImpl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import dao.INacionalidadDao;
import entidad.Nacionalidad;

public class NacionalidadDaoImpl implements INacionalidadDao{
	
	@Override
	public ArrayList<Nacionalidad> listarNacionalidades(){
		String query = "select IDNacionalidad as idNacionalidad, Nacionalidad as nacionalidad from nacionalidades;";
		ArrayList<Nacionalidad> listaNacionalidades = new ArrayList<>();
		
		try (Connection conexion = Conexion.getConnection();
				PreparedStatement statement = conexion.prepareStatement(query);
				ResultSet resultSet = statement.executeQuery()) {

			while (resultSet.next()) {
				Nacionalidad nacionalidad = new Nacionalidad();
				nacionalidad.setId(resultSet.getInt("idNacionalidad"));
				nacionalidad.setNacionalidad(resultSet.getString("nacionalidad"));
				listaNacionalidades.add(nacionalidad);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return listaNacionalidades;
	}
	
	
	@Override
	public Nacionalidad obtenerNacionalidadPorId(int id) {
		Nacionalidad nacionalidad = null;
		String query = "SELECT IDNacionalidad, Nacionalidad FROM nacionalidades WHERE IDNacionalidad = ?";
		
		try (Connection conexion = Conexion.getConnection();
				PreparedStatement statement = conexion.prepareStatement(query)) {

			// Establecer el parámetro del id
			statement.setInt(1, id);

			try (ResultSet resultSet = statement.executeQuery()) {
				if (resultSet.next()) {
					nacionalidad = new Nacionalidad();
					nacionalidad.setId(resultSet.getInt("idNacionalidad"));
					nacionalidad.setNacionalidad(resultSet.getString("nacionalidad"));
				}
			}

		} catch (Exception e) {
			e.printStackTrace();
		}

		return nacionalidad;
	}
	
}