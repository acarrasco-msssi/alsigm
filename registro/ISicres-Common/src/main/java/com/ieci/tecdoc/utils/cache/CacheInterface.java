//
// FileName: CacheInterface.java
//
package com.ieci.tecdoc.utils.cache;

import com.ieci.tecdoc.common.exception.SessionException;

/**
 * @author lmvicente
 * @version @since @creationDate 01-abr-2004
 */

public interface CacheInterface {

	/***************************************************************************************************************************************
	 * Attributes
	 **************************************************************************************************************************************/

	/***************************************************************************************************************************************
	 * Constructors
	 **************************************************************************************************************************************/

	/***************************************************************************************************************************************
	 * Public methods
	 **************************************************************************************************************************************/
	
	public String createCacheEntry() throws SessionException;
		
	public CacheBag getCacheEntry(String sessionID) throws SessionException;
		
	public void removeCacheEntry(String sessionID);
		
	/***************************************************************************************************************************************
	 * Protected methods
	 **************************************************************************************************************************************/

	/***************************************************************************************************************************************
	 * Private methods
	 **************************************************************************************************************************************/

	/***************************************************************************************************************************************
	 * Inner classes
	 **************************************************************************************************************************************/

	/***************************************************************************************************************************************
	 * Test brench
	 **************************************************************************************************************************************/

}
