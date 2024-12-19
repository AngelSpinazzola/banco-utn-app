package negocioImpl;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import dao.IMovimientoDao;
import daoImpl.Conexion;
import daoImpl.MovimientoDaoImpl;
import entidad.DatosDashboard;
import entidad.Movimiento;
import entidad.Prestamo;
import negocio.IMovimientoNegocio;

public class MovimientoNegocioImpl implements IMovimientoNegocio{
	IMovimientoDao iMovimientoDao;
	
	public MovimientoNegocioImpl() {
		this.iMovimientoDao = new MovimientoDaoImpl();
	}
	
	public void registrarMovimiento(Movimiento movimiento) {
		iMovimientoDao.registrarMovimiento(movimiento);
	}
	
	@Override
	public ArrayList<Movimiento> getMovimientosPorCliente(int idCliente, int page, int pageSize) {
		ArrayList<Movimiento> movimientos = iMovimientoDao.getMovimientosPorCliente(idCliente, page, pageSize);
		
		return movimientos;
	}
	
	@Override
	public int getTotalMovimientos(int idCliente) {
	    return iMovimientoDao.getTotalMovimientosPorCliente(idCliente);
	}
	
	
	@Override
	public int calcularTotalPaginas(int idCliente, int pageSize) {
	    int totalMovimientos = getTotalMovimientos(idCliente);
	    return (int) Math.ceil((double) totalMovimientos / pageSize);
	}
	
	//Métodos para reportes
	
	@Override
	public int getCantidadTransferenciasPorAnio(int anio) {
		String query = "select count(*) from movimientos where IDTipoMovimiento = 4 and year(fecha) = ?";
		
		int totalTransferencias = 0;
		
		try (Connection conexion = Conexion.getConnection();
		   PreparedStatement statement = conexion.prepareStatement(query)) {
		   statement.setInt(1, anio);	
			try (ResultSet rs = statement.executeQuery()) {
				if (rs.next()) {
					totalTransferencias = rs.getInt(1); 
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return totalTransferencias;
	}
	
	@Override
	public BigDecimal getMontoTransferenciasPorAnio(int anio) {
		String query = "SELECT SUM(m.Importe) as suma_transferencias FROM MOVIMIENTOS m WHERE m.IDTipoMovimiento = 4 AND YEAR(fecha) = ?";
		
		BigDecimal suma = BigDecimal.ZERO;
		
		try (Connection conn = Conexion.getConnection(); 
				PreparedStatement ps = conn.prepareStatement(query)) {
			ps.setInt(1, anio);
			ResultSet rs = ps.executeQuery();
			
			if (rs.next()) {
				suma = rs.getBigDecimal("suma_transferencias");
			}
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		return suma;
	}
	
	@Override
	public List<BigDecimal> getTransferenciasMensualesPorAnio(int anio){
		String query = "SELECT MONTH(Fecha) AS Mes, SUM(m.Importe) AS totalTransferencias\r\n" + 
				"FROM Movimientos m WHERE YEAR(Fecha) = ? AND m.IDTipoMovimiento = 4\r\n" + 
				"GROUP BY MONTH(Fecha)\r\n" + 
				"ORDER BY Mes;";
		
		List<BigDecimal> transferenciasMensuales = new ArrayList<>();
	    
	    try (Connection conn = Conexion.getConnection();
	         PreparedStatement ps = conn.prepareStatement(query)) {
	        
	        ps.setInt(1, anio);
	        ResultSet rs = ps.executeQuery();
	        
	        for (int i = 0; i < 12; i++) {
	        	transferenciasMensuales.add(BigDecimal.ZERO);
	        }
	        
	        while (rs.next()) {
	            int mes = rs.getInt("Mes");
	            BigDecimal totalTransferencias = rs.getBigDecimal("totalTransferencias");
	            
	            transferenciasMensuales.set(mes - 1, totalTransferencias != null ? totalTransferencias : BigDecimal.ZERO);
	        }
	        
	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	    
	    return transferenciasMensuales;
	}
	
	@Override
	public List<Integer> getAniosConTransferencias(){
		String query = "SELECT DISTINCT YEAR(m.Fecha) FROM Movimientos m WHERE m.IDTipoMovimiento = 4 ORDER BY YEAR(m.Fecha) DESC";
		
		List<Integer> aniosConTransferencias = new ArrayList<>();

	    try (Connection conn = Conexion.getConnection();
	         PreparedStatement ps = conn.prepareStatement(query)) {
	        
	        ResultSet rs = ps.executeQuery();
	        
	        while (rs.next()) {
	            int anio = rs.getInt(1); 
	            aniosConTransferencias.add(anio);
	        }
	        
	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	    
	    return aniosConTransferencias;
	}
}