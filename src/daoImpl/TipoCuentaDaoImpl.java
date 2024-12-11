package daoImpl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import dao.ITipoCuentaDao;
import entidad.TipoCuenta;

public class TipoCuentaDaoImpl implements ITipoCuentaDao{
	
	@Override
	public ArrayList<TipoCuenta> getTipoCuentas(){
		ArrayList<TipoCuenta> listaTipoCuentas = new ArrayList<>();
		
		String query = "select tc.IDTipoCuenta as idTipoCuenta, tc.Tipo as nombre from tipo_cuentas tc";
		
		try (Connection conexion = Conexion.getConnection();
				PreparedStatement statement = conexion.prepareStatement(query);
				ResultSet rs = statement.executeQuery()) {

			while (rs.next()) {
				TipoCuenta tipoCuenta = new TipoCuenta();

				tipoCuenta.setIdTipoCuenta(rs.getInt("idTipoCuenta"));
				tipoCuenta.setTipo(rs.getString("nombre"));
				
				listaTipoCuentas.add(tipoCuenta);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return listaTipoCuentas;
	}
}
