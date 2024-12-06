package daoImpl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import dao.ITipoPrestamoDao;
import entidad.Localidad;
import entidad.TipoPrestamo;

public class TipoPrestamoDaoImpl implements ITipoPrestamoDao {
	
	@Override
	public ArrayList<TipoPrestamo> getTipoPrestamos(){
		ArrayList<TipoPrestamo> listaTipoPrestamos = new ArrayList<>();
		
		String query = "select tp.IDTipoPrestamo as idTipo, tp.Tipo as nombre, tp.TNA as tna from tipo_prestamos tp";
		
		try (Connection conexion = Conexion.getConnection();
				PreparedStatement statement = conexion.prepareStatement(query);
				ResultSet rs = statement.executeQuery()) {

			while (rs.next()) {
				TipoPrestamo tipoPrestamo = new TipoPrestamo();

				tipoPrestamo.setIdTipoPrestamo(rs.getInt("idTipo"));
				tipoPrestamo.setNombreTipoPrestamo(rs.getString("nombre"));
				tipoPrestamo.setTna(rs.getBigDecimal("tna"));
				
				listaTipoPrestamos.add(tipoPrestamo);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return listaTipoPrestamos;
	}
}
