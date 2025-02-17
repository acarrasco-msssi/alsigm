package ieci.tdw.ispac.ispacmgr.action;

import ieci.tdw.ispac.api.ICatalogAPI;
import ieci.tdw.ispac.api.IInvesflowAPI;
import ieci.tdw.ispac.api.IWorklistAPI;
import ieci.tdw.ispac.api.impl.SessionAPI;
import ieci.tdw.ispac.api.item.IItem;
import ieci.tdw.ispac.api.item.IItemCollection;
import ieci.tdw.ispac.api.item.util.ListCollection;
import ieci.tdw.ispac.ispaclib.bean.BeanFormatter;
import ieci.tdw.ispac.ispaclib.bean.CacheFormatterFactory;
import ieci.tdw.ispac.ispaclib.bean.CollectionBean;
import ieci.tdw.ispac.ispaclib.context.ClientContext;
import ieci.tdw.ispac.ispaclib.dao.wl.WLTaskDAO;
import ieci.tdw.ispac.ispaclib.db.DbCnt;
import ieci.tdw.ispac.ispacmgr.menus.MenuFactory;
import ieci.tdw.ispac.ispacmgr.mgr.SchemeMgr;
import ieci.tdw.ispac.ispacweb.api.IManagerAPI;
import ieci.tdw.ispac.ispacweb.api.IState;
import ieci.tdw.ispac.ispacweb.api.ManagerAPIFactory;
import ieci.tdw.ispac.ispacweb.api.ManagerState;
import ieci.tdw.ispac.ispacweb.manager.TaskListFormatFactory;

import java.io.InputStream;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;

public class ShowTasksListAction extends BaseAction {
	public ActionForward executeAction(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response,
			SessionAPI session) throws Exception {

		ClientContext cct = session.getClientContext();

		IInvesflowAPI invesFlowAPI = session.getAPI();
		ICatalogAPI catalogAPI = invesFlowAPI.getCatalogAPI();

		DbCnt cnt = null;
		BeanFormatter formatter = null;
		InputStream istream = null;

		try {
			IWorklistAPI workListAPI = invesFlowAPI.getWorkListAPI();
			IManagerAPI managerAPI=ManagerAPIFactory.getInstance().getManagerAPI(cct);

			//S e establece el estado
			Map params = request.getParameterMap();
			IState newState = managerAPI.enterState(getStateticket(request),ManagerState.TASKSLIST,params);
			storeStateticket(newState,response);

			// Identificador del tramite en el catalogo
			int taskCtlId = newState.getTaskCtlId();
			// Identificador del tramite para el procedimiento
			int taskPcdId = newState.getTaskPcdId();

			// Cuando la bandeja de trabajo presenta los tr�mites agrupados por procedimiento
			// Identificador del procedimiento
			int pcdId = newState.getPcdId();

	        // Cargar el contexto de la cabecera (miga de pan)
	        SchemeMgr.loadContextHeader(newState, request, getResources(request), session);

	        // Men�s
			request.setAttribute("menus", MenuFactory.getTasksListMenu(cct,
		    		newState, getResources(request)));


			// obtenemos la lista de los datos de tr�mites
			IItemCollection itcTask = null;

			//Se obtiene la lista de tramites en funcion del estado y parametros.

			//Si se han recibido una lista de identificadores de tramites...
			if (request.getParameter("taskIds")!=null){

			    //...se muestran unicamente estos tramites
			    cnt = cct.getConnection();
              itcTask = new ListCollection(WLTaskDAO.getTasks(cnt,
			    		request.getParameterValues("taskIds")).toList());

			} else if (taskCtlId != 0) {

				// Si existe el identificador del tr�mite en el cat�logo
				// se obtienen todos los tramites abiertos

				// C�digo del tr�mite para obtener el formateador
				IItem ctTask = catalogAPI.getCTTask(taskCtlId);
				String taskCode = ctTask.getString("COD_TRAM");

				TaskListFormatFactory tasklistfactory = new TaskListFormatFactory(getISPACPath());

				// Tr�mites abiertos en un procedimiento?
				if (pcdId > 0) {

					// C�digo del procedimiento para obtener el formateador
					String pcdCode = null;
					IItem ctPcd = catalogAPI.getCTProcedure(pcdId);
					if (ctPcd != null) {
						pcdCode = ctPcd.getString("COD_PCD");
					}

					// Formateador para el listado de tr�mites teniendo en cuenta el procedimiento
					istream = tasklistfactory.getTaskListFormat(pcdId, pcdCode, taskCode);

					// Tr�mites activos para el tr�mite del procedimiento
					itcTask = workListAPI.getTasksCTL(taskCtlId, istream, pcdId);

					//Se reutiliza el istream para obtener el BeanFormatter
					//formatter = tasklistfactory.getBeanFormatter(pcdId, pcdCode, taskCode);

				} else {
					// Formateador para el listado de tr�mites sin tener en cuenta el procedimiento
					istream = tasklistfactory.getTaskListFormat(taskCode);

					// Tr�mites activos para el tr�mite de cat�logo
					itcTask = workListAPI.getTasksCTL(taskCtlId, istream);

					//Se reutiliza el istream para obtener el BeanFormatter
					//formatter = tasklistfactory.getBeanFormatter(taskCode);
				}

				// Propiedades del formateador para la vista
				istream.reset();
				formatter = tasklistfactory.getBeanFormatter(istream);

			} else if (taskPcdId != 0) { //Si existe el identificador del tr�mite para el procedimiento...

				IItem ctTaskPCD = catalogAPI.getCTTaskPCD(taskPcdId);
				if (ctTaskPCD != null) {

					// C�digo del tr�mite para obtener el formateador
					String taskCode = ctTaskPCD.getString("SPAC_CT_TRAMITES:COD_TRAM");

					// C�digo del procedimiento para obtener el formateador
					String pcdCode = null;
					pcdId = ctTaskPCD.getInt("SPAC_P_TRAMITES:ID_PCD");
					if (pcdId > 0) {
						IItem ctPcd = catalogAPI.getCTProcedure(pcdId);
						if (ctPcd != null) {
							pcdCode = ctPcd.getString("COD_PCD");
						}
					}

					// Formateador para el listado de tr�mites teniendo en cuenta el procedimiento
					TaskListFormatFactory tasklistfactory = new TaskListFormatFactory(getISPACPath());
					istream = tasklistfactory.getTaskListFormat(pcdId, pcdCode, taskCode);

					// Tr�mites activos para el tr�mite del procedimiento
					itcTask = workListAPI.getTasksPCD(taskPcdId, istream);

					//Se reutiliza el istream para obtener el BeanFormatter
					//formatter = tasklistfactory.getBeanFormatter(pcdId, pcdCode, taskCode);

					// Propiedades del formateador para la vista
					istream.reset();
					formatter = tasklistfactory.getBeanFormatter(istream);

				} else {
					itcTask = workListAPI.getTasksPCD(taskPcdId);
				}
			}

			// Lista de tramites en la peticion
			List expTaskList = CollectionBean.getBeanList(itcTask);
			request.setAttribute("ExpTaskList",expTaskList);

			///////////////////////////////////////////////
			// Formateador
			if (formatter == null) {
				// Formateador por defecto
				CacheFormatterFactory factory = CacheFormatterFactory.getInstance();
				formatter = factory.getFormatter(getISPACPath("/digester/taskprocessformatter.xml"));
			}

			request.setAttribute("Formatter", formatter);

			return mapping.findForward("success");

		} finally{
		    cct.releaseConnection(cnt);
		}
	}
}
