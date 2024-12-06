package daoImpl;

import java.math.BigDecimal;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import dao.ICuentaDao;
import dao.IPrestamoDao;
import entidad.Cliente;
import entidad.Cuenta;
import entidad.Direccion;
import entidad.Localidad;
import entidad.Nacionalidad;
import entidad.Provincia;
import entidad.TipoCuenta;

public class CuentaDaoImpl implements ICuentaDao {
	
	@Override
	public ArrayList<Cuenta> getCuentasDelCliente(int idCliente) {
		ArrayList<Cuenta> cuentas = new ArrayList<>();
		
		String query = "select IDCuenta as idCuenta, cu.NumeroCuenta as numeroCuenta, cu.CBU as cbu,  cu.FechaCreacion as fechaCreacion, cu.Saldo as saldo,tc.IDTipoCuenta as idTipo,  tc.Tipo as tipo \r\n" + 
				"from cuentas cu \r\n" + 
				"inner join tipo_cuentas tc on cu.IDTipoCuenta = tc.IDTipoCuenta \r\n" + 
				"where cu.IDCliente = ? and cu.ESTADO = 1";

		try (Connection conn = Conexion.getConnection(); PreparedStatement ps = conn.prepareStatement(query)) {
			ps.setInt(1, idCliente);
			ResultSet rs = ps.executeQuery();

			while (rs.next()) {
				TipoCuenta tipoCuenta = new TipoCuenta(rs.getInt("idTipo"), rs.getString("tipo"));
				Cuenta cuenta = new Cuenta();
				
				cuenta.setIdCuenta(rs.getInt("idCuenta"));
				cuenta.setNumeroCuenta(rs.getInt("numeroCuenta"));
				cuenta.setCbu(rs.getString("cbu"));
				cuenta.setFechaCreacion(rs.getDate("fechaCreacion"));
				cuenta.setSaldo(rs.getBigDecimal("saldo"));

				cuenta.setTipoCuenta(tipoCuenta);
				
				cuentas.add(cuenta);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return cuentas;
	}
	
	@Override
	public boolean modificarSaldo(int idCuenta, BigDecimal saldo) {
	    String query = "UPDATE cuentas SET Saldo = ? WHERE NumeroCuenta = ? AND ESTADO = 1";
	    boolean isUpdated = false;

	    try (Connection conn = Conexion.getConnection(); PreparedStatement ps = conn.prepareStatement(query)) {
	        ps.setBigDecimal(1, saldo);
	        ps.setInt(2, idCuenta);

	        int rowsAffected = ps.executeUpdate();

	        if (rowsAffected > 0) {
	            isUpdated = true;
	        }
	    } catch (Exception e) {
	        e.printStackTrace(); 
	    }

	    return isUpdated;
	}
	
	@Override
	public int eliminarCuenta(int idCuenta) {
		String query = "delete from cuentas where IDCuenta = ?";
		IPrestamoDao iPrestamoDao = new PrestamoDaoImpl();
		
		int prestamosPorCuenta = iPrestamoDao.getPrestamosPorCuenta(idCuenta);
		
		if(prestamosPorCuenta > 0) {
			return 1; //Tiene prestamos la cuenta, por ende no puede eliminarse
		}
		
		try (Connection cn = Conexion.getConnection(); PreparedStatement ps = cn.prepareStatement(query)){
			ps.setInt(1, idCuenta);
			
			int rowsAffected = ps.executeUpdate();
			
			if(rowsAffected > 0) {
				return 0; //Exito
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return 2; //Error
	}
	
	@Override
	public boolean validarSaldo(BigDecimal monto, String cbuOrigen) {
		String query = "select c.Saldo as saldo from cuentas c where cbu = ?";
		BigDecimal saldo = null;
		

		try (Connection conn = Conexion.getConnection(); PreparedStatement ps = conn.prepareStatement(query)) {
			ps.setString(1,  cbuOrigen); 
			ResultSet rs = ps.executeQuery();
			
			while (rs.next()) {
				saldo = rs.getBigDecimal("saldo");
				
				if (saldo.subtract(monto).compareTo(BigDecimal.ZERO) < 0) {
	                return false;  //Si el saldo menos el monto a transferir es menor a 0, no se puede realizar la transferencia
	            }
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return true; //Si el saldo es suficiente, se retorna true
	}
	
	@Override
	public boolean validarCuentaDestino(String cbuDestino) {
		String query = "select c.ESTADO as estado from cuentas c where cbu = ?";
		boolean estado = false;
		
		try (Connection conn = Conexion.getConnection(); PreparedStatement ps = conn.prepareStatement(query)) {
			ps.setString(1,  cbuDestino); 
			ResultSet rs = ps.executeQuery();
			
			if(rs.next()) {
				estado = rs.getBoolean("estado");
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return estado; //Significa que esta activa la cuenta destino
	}
	
	public boolean transferir(String cbuOrigen, String cbuDestino, String _monto) {
		BigDecimal monto = new BigDecimal(_monto);
		
		String sp = "{ CALL SP_RealizarTransferencia(?,?,?) }";
		
		try (Connection cn = Conexion.getConnection(); CallableStatement cs = cn.prepareCall(sp)) {
			cs.setString(1, cbuOrigen);
			cs.setString(2, cbuDestino);
			cs.setBigDecimal(3, monto);
			
			cs.executeUpdate();  
	       
	        return true;
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return false;
	}
	


}