package entidad;

import java.math.BigDecimal;
import java.util.Date;

public class Movimiento {
	private int id;
	private Date fecha;
	private String detalle;
	private BigDecimal monto;
	private Integer idCuentaEmisor;
	private int idCuentaReceptor;
	private TipoMovimiento tipoMovimiento;
	
	public Movimiento() {
		super();
		this.tipoMovimiento = new TipoMovimiento();
	}
	
	public int getId() {
		return id;
	}
	public void setId(int id) {
		this.id = id;
	}
	public Date getFecha() {
		return fecha;
	}
	public void setFecha(Date fecha) {
		this.fecha = fecha;
	}
	public String getDetalle() {
		return detalle;
	}
	public void setDetalle(String detalle) {
		this.detalle = detalle;
	}
	public BigDecimal getMonto() {
		return monto;
	}
	public void setMonto(BigDecimal monto) {
		this.monto = monto;
	}
	public Integer getIdCuentaEmisor() {
		return idCuentaEmisor;
	}
	public void setIdCuentaEmisor(Integer idCuentaEmisor) {
		this.idCuentaEmisor = idCuentaEmisor;
	}
	public int getIdCuentaReceptor() {
		return idCuentaReceptor;
	}
	public void setIdCuentaReceptor(int idCuentaReceptor) {
		this.idCuentaReceptor = idCuentaReceptor;
	}
	public TipoMovimiento getTipoMovimiento() {
		return tipoMovimiento;
	}
	public void setTipoMovimiento(TipoMovimiento tipoMovimiento) {
		this.tipoMovimiento = tipoMovimiento;
	}
	
}