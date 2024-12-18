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
	public int agregarCuenta(int idCliente, int idTipoCuenta) {
		ArrayList<Cuenta> cuentas = getCuentasDelCliente(idCliente);
		
		if(cuentas.size() == 3) {
			return 3; // Tiene 3 cuentas, no se puede crear
		}
		
		String query = "{CALL SP_CrearCuenta(?,?)}";
		
		try (Connection cn = Conexion.getConnection(); CallableStatement cs = cn.prepareCall(query)) {
			cs.setInt(1, idCliente);
			cs.setInt(2, idTipoCuenta);

			cs.executeUpdate();  
	       
	        return 1; 
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return 2;
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
		String query = "update Cuentas set Estado = 0 where IDCuenta = ?";
		IPrestamoDao iPrestamoDao = new PrestamoDaoImpl();
		
		int prestamosPorCuenta = iPrestamoDao.getPrestamosPorCuenta(idCuenta);
		
		if(prestamosPorCuenta > 0) {
			return 1; //Tiene prestamos la cuenta
		}
		
		BigDecimal monto = getSaldoCuentaCliente(idCuenta);
		BigDecimal cero = new BigDecimal("0");
		
		if (monto.compareTo(cero) > 0) {
		    return 2; // La cuenta tiene saldo superior a 0
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
		return 3; //Error
	}
	
	@Override
	public BigDecimal getSaldoCuentaCliente(int idCuenta) {
	    String query = "SELECT saldo FROM cuentas WHERE idcuenta = ?";
	    BigDecimal saldo = BigDecimal.ZERO;
	      
	    try (Connection conn = Conexion.getConnection(); 
	         PreparedStatement ps = conn.prepareStatement(query)) {
	        ps.setInt(1, idCuenta);
	        ResultSet rs = ps.executeQuery();
	        
	        if (rs.next()) {
	            saldo = rs.getBigDecimal("saldo");
	        }
	        
	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	    return saldo;
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
	
	@Override
	public boolean tieneCuentas(int idCliente) {
	    String query = "SELECT COUNT(*) > 0 AS tieneCuentas FROM cuentas WHERE IDCliente = ? and ESTADO = 1";
	    
	    try (Connection conexion = Conexion.getConnection();
	         PreparedStatement st = conexion.prepareStatement(query)) {
	        st.setInt(1, idCliente);
	        
	        try (ResultSet rs = st.executeQuery()) {
	            if (rs.next()) {
	                return rs.getBoolean("tieneCuentas");
	            }
	        }
	    } catch (SQLException e) {
	        e.printStackTrace();
	    }
	    
	    return false;
	}
	
	@Override
	public int getTotalCuentasActivas() {
		String query = "select count(*) from cuentas where ESTADO = 1";
		
		int totalCuentas = 0;
		
		try (Connection conexion = Conexion.getConnection();
		   PreparedStatement statement = conexion.prepareStatement(query)) {

			try (ResultSet rs = statement.executeQuery()) {
				if (rs.next()) {
					totalCuentas = rs.getInt(1); 
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return totalCuentas;
	}


}