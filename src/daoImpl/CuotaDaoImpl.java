package daoImpl;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

import dao.ICuotaDao;
import entidad.Cuota;

public class CuotaDaoImpl implements ICuotaDao{
	
	@Override
	public ArrayList<Cuota> getCuotasPorPrestamo(int idPrestamo, int page, int pageSize){
		ArrayList<Cuota> listaCuotas = new ArrayList<>();

	    int offset = (page - 1) * pageSize;
		
		String query = "select \r\n" + 
				"	pl.IDPlazo as idCuota,\r\n" + 
				"	pl.NroCuota as numeroCuota, \r\n" + 
				"	pl.FechaDeVencimiento as fechaVencimiento, \r\n" + 
				"	pl.FechaDePago as fechaPago, \r\n" + 
				"	pl.ImporteAPagarCuotas as importeCuota,\r\n" + 
				"    pl.Estado as estado\r\n" + 
				"from plazos pl\r\n" + 
				"where pl.IDPrestamo = ?\r\n" + 
				"limit ? offset ?";
		
		try (Connection conn = Conexion.getConnection(); PreparedStatement ps = conn.prepareStatement(query)) {
	        ps.setInt(1, idPrestamo);
	        ps.setInt(2, pageSize);
	        ps.setInt(3, offset);
	        ResultSet rs = ps.executeQuery();

	        while (rs.next()) {
	        	Cuota cuota = new Cuota();
	            
	            cuota.setIdPlazo(rs.getInt("idCuota"));
	            cuota.setNumeroDeCuota(rs.getInt("numeroCuota"));
	            cuota.setFechaVencimientoCuota(rs.getDate("fechaVencimiento"));
	            cuota.setFechaPagoCuota(rs.getDate("fechaPago"));
	            cuota.setImporteCuota(rs.getBigDecimal("importeCuota"));
	            cuota.setEstado(rs.getInt("estado"));
	            
	            listaCuotas.add(cuota);
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	    }
		
	    return listaCuotas;
	}
	
	@Override
	public int getTotalCuotasCount(int idPrestamo) {
		String query = "select count(*) from plazos where IDPrestamo = ?";
		
		int totalCuotas = 0;

		try (Connection conexion = Conexion.getConnection();
				PreparedStatement statement = conexion.prepareStatement(query)) {

			statement.setInt(1, idPrestamo);

			try (ResultSet rs = statement.executeQuery()) {
				if (rs.next()) {
					totalCuotas = rs.getInt(1); 
				}
			}

		} catch (Exception e) {
			e.printStackTrace();
		}
		return totalCuotas;
	}
	
	@Override
	public BigDecimal getMontoTotalCuotasAPagar(String idsCuotas) {
		String query = "SELECT SUM(ImporteAPagarCuotas) AS MontoTotal FROM PLAZOS WHERE FIND_IN_SET(IDPlazo, ?) > 0";
        
        BigDecimal montoTotal = BigDecimal.ZERO;

        try (Connection conexion = Conexion.getConnection();
             PreparedStatement statement = conexion.prepareStatement(query)) {

            statement.setString(1, idsCuotas);

            try (ResultSet rs = statement.executeQuery()) {
                if (rs.next()) {
                    montoTotal = rs.getBigDecimal("MontoTotal");
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return montoTotal;
	}
}
