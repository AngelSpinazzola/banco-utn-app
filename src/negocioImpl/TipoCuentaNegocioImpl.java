package negocioImpl;

import java.util.ArrayList;
import dao.ITipoCuentaDao;
import daoImpl.TipoCuentaDaoImpl;
import entidad.TipoCuenta;
import negocio.ITipoCuentaNegocio;

public class TipoCuentaNegocioImpl implements ITipoCuentaNegocio{
	ITipoCuentaDao iTipoCuenta = new TipoCuentaDaoImpl();
	
	@Override
	public ArrayList<TipoCuenta> getTipoCuentas(){
		ArrayList<TipoCuenta> listaTipoCuentas = iTipoCuenta.getTipoCuentas();
		
		return listaTipoCuentas;
	}
}
