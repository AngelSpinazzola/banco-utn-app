package entidad;

import java.math.BigDecimal;
import java.util.List;

public class DatosDashboard {
	private Integer anioSeleccionado;
    private List<Integer> aniosDisponibles;
    private BigDecimal[] transferencias;
    private BigDecimal[] prestamos;
    
    public DatosDashboard() {
    	
    }

	public Integer getAnioSeleccionado() {
		return anioSeleccionado;
	}

	public void setAnioSeleccionado(Integer anioSeleccionado) {
		this.anioSeleccionado = anioSeleccionado;
	}

	public List<Integer> getAniosDisponibles() {
		return aniosDisponibles;
	}

	public void setAniosDisponibles(List<Integer> aniosDisponibles) {
		this.aniosDisponibles = aniosDisponibles;
	}

	public BigDecimal[] getTransferencias() {
		return transferencias;
	}

	public void setTransferencias(BigDecimal[] transferencias) {
		this.transferencias = transferencias;
	}

	public BigDecimal[] getPrestamos() {
		return prestamos;
	}

	public void setPrestamos(BigDecimal[] prestamos) {
		this.prestamos = prestamos;
	}
    
    
}
