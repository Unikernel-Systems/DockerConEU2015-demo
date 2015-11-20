<?php

/*
 * Nibbleblog -
 * http://www.nibbleblog.com
 * Author Diego Najar

 * All Nibbleblog code is released under the GNU General Public License.
 * See COPYRIGHT.txt and LICENSE.txt.
*/

class Filesystem {

	public static function get_images($regex)
	{
		return self::ls(PATH_UPLOAD, $regex, '*', false, false, false);
	}

	// Devuelve un arreglo con el listado de archivos
	// $path con una barra al final, ej: /home/
	// $file_expression : *.0.*.*.*.*.*.*.*.*
	// $ext : xml
	// $flag_dir : si quiero listar directorios
	// $sort_asc_numeric : ordeno ascedente numerico
	// $sort_desc_numeric : ordeno descendente numerico
	public static function ls($path, $file_expression = NULL, $ext, $flag_dir = false, $sort_asc_numeric = false, $sort_desc_numeric = true)
	{
		if($flag_dir)
		{
			$files = glob($path . $file_expression, GLOB_ONLYDIR);
		}
		else
		{
			$files = glob($path . $file_expression . '.' . $ext);
		}

		if( ($files==false) || (empty($files)) )
		{
			$files = array();
		}

		foreach($files as $key=>$file)
		{
			$files[$key] = basename($file);
		}

		// Sort
		if($sort_asc_numeric)
		{
			sort($files, SORT_NUMERIC);
		}
		elseif($sort_desc_numeric)
		{
			rsort($files, SORT_NUMERIC);
		}

		return $files;
	}
}

?>