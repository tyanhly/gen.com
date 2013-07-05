<?php
class Gen_Site{

    const PROJECT_OUTPUT_PATH                   = '/server/staff/tung.ly/Zend/workspaces/DefaultWorkspace7/tmp/';
    const MODEL_ABSTRACT_CLASS                  = 'Base_Db_Table_Abstract';
    const FORM_ABSTRACT_CLASS                   = 'Zend_Form';

    const CONTROLLER_ABSTRACT_CLASS             = 'Zend_Controller_Action';
    const FORM_ELEMENT_TEXT                     = 'text';
    const FORM_ELEMENT_INT                      = 'int';
    const FORM_ELEMENT_FLOAT                    = 'float';
    const FORM_ELEMENT_DATE                     = 'date';
    const FORM_ELEMENT_TEXTAREA                 = 'textarea';
    const FORM_ELEMENT_MULTI_CHECKBOX           = 'checkbox';
    const FORM_ELEMENT_SELECT                   = 'radio';
    const FORM_ELEMENT_HIDDEN                   = 'hidden';
    const FORM_ELEMENT_SUBMIT                   = 'submit';

    private $_padding1 = '    ';
    private $_padding2 = '        ';
    private $_padding3 = '            ';
    private $_padding4 = '                ';
    private $_padding5 = '                    ';

    protected $_formElementTypes = array(
        self::FORM_ELEMENT_TEXT => array(
            'char',
            'varchar',
        ),
        self::FORM_ELEMENT_INT => array(
            'int',
        ),
        self::FORM_ELEMENT_FLOAT => array(
            'float',
            'double',
            'decimal',
        ),
        self::FORM_ELEMENT_DATE => array(
            'date',
            'time',
        ),
        self::FORM_ELEMENT_TEXTAREA => array(
            'text',
            'blob',
        ),
        self::FORM_ELEMENT_MULTI_CHECKBOX => array(
            'set'
        ),
        self::FORM_ELEMENT_SELECT => array(
            'enum'
        ),
    );


    private $_configs;

    private $_db;
    private $_schemaDb;
    private $_templatePath;
    private $_outputPath;

    private $_tableNames;
    private $_fields = array();
    private $_defendentTables = array();
    private $_mapTables = array();

    public  static $messages;
    public function __construct($configs){

        self::$messages = '';
        defined('GEN_PATH')
            || define('GEN_PATH', realpath(dirname(__FILE__)));
        $this->_templatePath = GEN_PATH . '/Templates/Template1';
        $this->_outputPath   = self::PROJECT_OUTPUT_PATH . $configs['Site'];

        $this->_configs      = $configs;
        $this->_db = Zend_Db::factory(
            'PDO_MYSQL',
            array(
                'host'     => $configs['DatabaseHost'],
                'dbname'   => $configs['DatabaseName'],
                'username' => $configs['DatabaseUsername'],
                'password' => $configs['DatabasePassword'],
            )
        );

        $this->_schemaDb = Zend_Db::factory(
            'PDO_MYSQL',
            array(
                'host'     => $configs['DatabaseHost'],
                'dbname'   => 'information_schema',
                'username' => $configs['DatabaseUsername'],
                'password' => $configs['DatabasePassword'],
            )
        );
//        Zend_Db_Table::setDefaultAdapter($db);
    }

    public function genAll(){
        $this->genModels();
        $this->genControllers();
        $this->genViews();
        $this->genForms();
        $this->genApplicationIni();
        $this->genNavigationIni();
    }

    public function deploy(){
        $this->copyFiles();
        $this->genAll();
    }

    public function copyFiles(){
        self::putMsg("<h2>Copy Files</h2>");
        echo $command = "cp -rf {$this->_templatePath}/project {$this->_outputPath}";
        $msg = shell_exec($command);
        self::putMsg("Command: $command");
    }


    public function genNavigationIni(){
        self::putMsg("<h2>Create navigation.ini</h2>");

        $dirPath = $this->_getNavigationDir();
        $this->_createDirStructure($dirPath);
        $itemTemplate = '
;********************************************************************
;%%TABLE_NAME
;********************************************************************
navigation.%%TABLE_NAME%%.label = %%NAV_NAME%%
navigation.%%TABLE_NAME%%.uri   = #

navigation.%%TABLE_NAME%%.pages.%%TABLE_NAME%%.label      = %%SHOW_NAME%%
navigation.%%TABLE_NAME%%.pages.%%TABLE_NAME%%.controller = %%CONTROLLER%%
navigation.%%TABLE_NAME%%.pages.%%TABLE_NAME%%.action     = %%ACTION%%
navigation.%%TABLE_NAME%%.pages.%%TABLE_NAME%%.resource   = %%CONTROLLER%%.%%ACTION%%
navigation.%%TABLE_NAME%%.pages.%%TABLE_NAME%%.visible    = true

';
        $tableNames = $this->_getTableNames();
        $tmpArray = array('[run]');
        foreach ($tableNames as $tableName){

            $variables = array(
                '%%TABLE_NAME%%' => $tableName,
                '%%NAV_NAME%%'   => $this->_camelCaseToSpace($tableName),
                '%%SHOW_NAME%%'  => $this->_camelCaseToSpace($tableName),
                '%%CONTROLLER%%' => $this->_camelCaseToDash($tableName),
                '%%ACTION%%'     => 'show-' . $this->_camelCaseToDash($tableName),
            );

            $tmpArray[] = str_replace(array_keys($variables), $variables, $itemTemplate);
        }

        $this->_createFile($dirPath, 'navigation.ini', implode("\n",$tmpArray));
    }

    public function genApplicationIni(){
        self::putMsg("<h2>Create application.ini</h2>");

        $dirPath = $this->_getConfigsDir();
        $this->_createDirStructure($dirPath);

        $applicationTemplatePath = $this->_templatePath . '/application.ini.template';

        $variables = array(
            '%%HOST%%'         => $this->_configs['DatabaseHost'],
            '%%USERNAME%%'     => $this->_configs['DatabaseUsername'],
            '%%PASSWORD%%'     => $this->_configs['DatabasePassword'],
            '%%DBNAME%%'       => $this->_configs['DatabaseName'],
        );

        $content = file_get_contents($applicationTemplatePath);
        $content = str_replace(array_keys($variables), $variables, $content);
        $this->_createFile($dirPath, 'application.ini', $content);
    }

    /**
     * @param array $field
     * @return string|multitype:string |string
     */
    protected function _getFormElementType($field){
        $key = $field['Key'];
        $typeGroup = $field['Type'];
        // return hidden type if $field is primary key
        if($key == 'PRI'){
            return self::FORM_ELEMENT_HIDDEN;
        }
        foreach ($this->_formElementTypes  as $typeGroupKey => $typeGroup){
            foreach($typeGroup as $type){
                if(false !==(strpos($field['Type'],$type))){
                    return $typeGroupKey;
                }
            }
        }
        //if $field['Type'] would not been defined in _formElementTypes.
        return self::FORM_ELEMENT_TEXT;
    }

    public function genModels(){
        self::putMsg("<h2>Create Models</h2>");
        $dirPath = $this->_getModelDir();
        $this->_createDirStructure($dirPath);
        $tableNames = $this->_getTableNames();


        foreach ($tableNames as $tableName){
            //create file Model
            $fields = $this->_getFieldsInTable($tableName);
            $content = $this->_getContentModel($tableName,$fields);
            $this->_createFile($dirPath, ucfirst($tableName) . '.php', $content);
        }
    }

    public function genForms(){
        self::putMsg("<h2>Create Forms</h2>");
        $dirPath = $this->_getFormDir();
        $this->_createDirStructure($dirPath);
        $tableNames = $this->_getTableNames();


        foreach ($tableNames as $tableName){
            //create file Model
            $fields = $this->_getFieldsInTable($tableName);
            $content = $this->_getContentForm($tableName, $fields);
            $this->_createFile($dirPath, ucfirst($tableName) . '.php', $content);
        }
    }

    public function genViews(){

        self::putMsg("<h2>Create Views</h2>");
        $tableNames = $this->_getTableNames();

        foreach ($tableNames as $tableName){

            $scriptDir   = $this->_getScriptDir($tableName);
            $partialDir  = $this->_getPartialDir($tableName);

            $this->_createDirStructure($partialDir);

            $fields = $this->_getFieldsInTable($tableName);


            $showAllContent   = $this->_getContentViewShowAll($tableName,$fields);
            $this->_createFile($scriptDir, $this->_getViewShowAllFileName($tableName), $showAllContent);

            $showAllRecordContent   = $this->_getViewShowAllRecordContent($tableName,$fields);
            $this->_createFile($partialDir, $this->_getViewShowRecordFileName($tableName), $showAllRecordContent);

            $updateContent    = $this->_getViewUpdateContent($tableName,$fields);
            $this->_createFile($scriptDir, $this->_getViewUpdateFileName($tableName), $updateContent);

            $addContent       = $this->_getViewAddContent($tableName,$fields);
            $this->_createFile($scriptDir, $this->_getViewAddFileName($tableName), $addContent);

        }
    }

    private function _getScriptDir($tableName){
        $dirPath = $this->_getViewDir();
        $viewDirName = $this->_camelCaseToDash($tableName);
        $t = "$dirPath/$viewDirName";
//        echo $t;
        return $t;
    }
    private function _getPartialDir($tableName){

        $dirPath = $this->_getScriptDir($tableName);
        $t = "$dirPath/_partial";
//        echo $t;die;
        return $t;
    }
    private function _getViewShowAllFileName($tableName){
        $t = "show-" . $this->_camelCaseToDash($tableName) . '.phtml';
        return $t;
    }
    private function _getViewShowRecordFileName($tableName){
        $t = "show-" . $this->_camelCaseToDash($tableName) . '.phtml';
        return $t;
    }
    private function _getViewAddFileName($tableName){
        $t = "add-" . $this->_camelCaseToDash($tableName) . '.phtml';
        return $t;
    }
    private function _getViewUpdateFileName($tableName){
        $t = "update-" . $this->_camelCaseToDash($tableName) . '.phtml';
        return $t;
    }

    private function _camelCaseToDash($string){

        $filter = new Zend_Filter_Word_CamelCaseToDash();
        $string = $filter->filter($string);
        return strtolower($string);

    }

    private function _camelCaseToSpace($string){
        $filter = new Zend_Filter_Word_CamelCaseToSeparator();
        $string = $filter->filter($string);
        return $string;

    }

    public function genControllers(){
        self::putMsg("<h2>Create Controllers</h2>");
        $dirPath = $this->_getControllerDir();
        $this->_createDirStructure($dirPath);
        $tableNames = $this->_getTableNames();


        foreach ($tableNames as $tableName){
            //create file Model
            $fields = $this->_getFieldsInTable($tableName);
            $content = $this->_getContentController($tableName,$fields);
            $this->_createFile($dirPath, ucfirst($tableName) . 'Controller.php', $content);
        }
    }

    private function _getConfigsDir(){
//        Zend_Debug::dump($this->_configs);die;
        return $this->_outputPath . '/application/configs/';
    }

    private function _getNavigationDir(){
//        Zend_Debug::dump($this->_configs);die;
        return $this->_outputPath . '/application/layouts/';
    }

    private function _getModelDir(){
//        Zend_Debug::dump($this->_configs);die;
        return $this->_outputPath . '/application/models/' . $this->_configs['Schema'];
    }

    private function _getFormDir(){
//        Zend_Debug::dump($this->_configs);die;
        return $this->_outputPath . '/application/forms/' . $this->_configs['Schema'];
    }

    private function _getViewDir(){
//        Zend_Debug::dump($this->_configs);die;
        return $this->_outputPath . '/application/views/scripts';
    }

    private function _getControllerDir(){
//        Zend_Debug::dump($this->_configs);die;
        return $this->_outputPath . '/application/controllers';
    }

    /**
     * This function called from DbTable creating
     * @param string $tableName
     * @return string for $_referenceMaps variable
     */
    private function _getStrReferenceMap($tableName){
        $strReferenceMap = '';

        $refTableNames = $this->_getReferencedTableNames($tableName);

        foreach($refTableNames as $key => $referencedTable){
            $refTableNames[$key] = $this->_getStrReferenceItem($tableName,$referencedTable);
        }
        $strReferenceMap = implode("\n", $refTableNames);

        return $strReferenceMap;
    }


    /**
     * @desc return foreign key column
     *       and referenced column
     * @param string $tableName
     * @param string $referencedTableName
     * @return array:
     */
    private function _getForeignKeyInfos($tableName, $referencedTableName){
        $sql = "SELECT KEY_COLUMN_USAGE.COLUMN_NAME,
                       KEY_COLUMN_USAGE.REFERENCED_COLUMN_NAME
                FROM TABLE_CONSTRAINTS
                INNER JOIN KEY_COLUMN_USAGE
                  ON TABLE_CONSTRAINTS.CONSTRAINT_NAME = KEY_COLUMN_USAGE.CONSTRAINT_NAME
                    AND TABLE_CONSTRAINTS.TABLE_SCHEMA = KEY_COLUMN_USAGE.CONSTRAINT_SCHEMA
                WHERE TABLE_CONSTRAINTS.TABLE_SCHEMA = '{$this->_configs['DatabaseName']}'
                  AND TABLE_CONSTRAINTS.CONSTRAINT_TYPE = 'FOREIGN KEY'
                  AND KEY_COLUMN_USAGE.TABLE_NAME = '$tableName'
                  AND KEY_COLUMN_USAGE.REFERENCED_TABLE_NAME = '$referencedTableName'";

        $tables = $this->_schemaDb->fetchAll($sql);

        return $tables;

    }

    /** @desc this function is used in _getFormElement<type>Content
     * @param string $variableName
     * @param array $field
     * @return string|string
     */
    protected function _getStrRequiredForElementForm($variableName, $field){
        if($field['Null']=='NO'){
            return "{$variableName}->setRequired(true);";
        }
        return "{$variableName}->setRequired(false);";
    }


    protected function _getStrMultiOptions($type){
        $arrTmp = array();
        //return: set('1','2','3')*
        $arrTmp = explode('(', $type);
        //return: '1','2','3')*
        $arrTmp = explode(')', $arrTmp[1]);
        //return: '1','2','3'
        $arrTmp = explode(',', $arrTmp[0]);

        $arrOptions = array();
        foreach($arrTmp as $option){
            $arrOptions[] = $option . " => " . $option ;
        }

        $result = 'array(' . implode(', ', $arrOptions) . ')';
        return $result;
    }

    /**
     * @desc    get Element whose type is 'Text'
     * @param array $field
     * @return string
     */
    protected function _getFormElementTextContent($field){
        $variableName = "$" . lcfirst($field['Field']);
        $arrTmp = array();

        $arrTmp[] = "$variableName = new Zend_Form_Element_Text('{$field['Field']}');";

        $arrTmp[] = "{$variableName}->setLabel('{$field['Field']}');";

        $arrTmp[] = "{$variableName}->addFilter('StringTrim');";

        $arrTmp[] = $this->_getStrRequiredForElementForm($variableName, $field);

        $arrTmp[] = "{$variableName}->setDecorators(array('ViewHelper'));";

        $arrTmp[] = "\$this->addElement($variableName);\n";

        $content = implode("\n" . $this->_padding2 , $arrTmp);
        return $content;

    }
    /**
     * @desc    get Element whose type is 'Number'
     * @param array $field
     * @param string $type
     * @return string
     */
    protected function _getFormElementNumberContent($field, $type = 'Int'){
        $variableName = "$" . lcfirst($field['Field']);
        $arrTmp = array();
        $arrTmp[] = "$variableName = new Zend_Form_Element_Text('{$field['Field']}');";

        $arrTmp[] = "{$variableName}->setLabel('{$field['Field']}');";

        $arrTmp[] = "{$variableName}->addFilter('StringTrim');";

        $arrTmp[] = "{$variableName}->addValidator('{$type}');";

        $arrTmp[] = $this->_getStrRequiredForElementForm($variableName, $field);

        $arrTmp[] = "{$variableName}->setDecorators(array('ViewHelper'));";

        $arrTmp[] = "\$this->addElement($variableName);\n";

        $content = implode("\n" . $this->_padding2, $arrTmp);
        return $content;

    }

    /**
     * @desc    get Element whose type is 'Date'
     * @param array $field
     * @return string
     */
    protected function _getFormElementDateContent($field){
        $variableName = "$" . lcfirst($field['Field']);
        $arrTmp = array();
        $arrTmp[] = "$variableName = new Zend_Form_Element_Text('{$field['Field']}');";

        $arrTmp[] = "{$variableName}->setLabel('{$field['Field']}');";

        $arrTmp[] = "{$variableName}->addFilter('StringTrim');";

        $arrTmp[] = "{$variableName}->addValidator('Date');";

        $arrTmp[] = $this->_getStrRequiredForElementForm($variableName, $field);

        $arrTmp[] = "{$variableName}->setDecorators(array('ViewHelper'));";

        $arrTmp[] = "\$this->addElement($variableName);\n";

        $content = implode("\n" . $this->_padding2, $arrTmp);
        return $content;

    }

    /**
     * @desc    get Element whose type is 'TextArea'
     * @param array $field
     * @return string
     */
    protected function _getFormElementTextAreaContent($field){
        $variableName = "$" . lcfirst($field['Field']);
        $arrTmp = array();

        $arrTmp[] =  "$variableName = new Zend_Form_Element_Textarea('{$field['Field']}');";
        $arrTmp[] = "{$variableName}->setLabel('{$field['Field']}');";
        $arrTmp[] = $this->_getStrRequiredForElementForm($variableName, $field);

        $arrTmp[] = "{$variableName}->setDecorators(array('ViewHelper'));";

        $arrTmp[] = "\$this->addElement($variableName);\n";

        $content = implode("\n"  . $this->_padding2, $arrTmp);
        return $content;
    }
    /**
     * @desc    get Element whose type is 'set'('MultiCheckbox')
     * @param array $field
     * @return string
     */
    protected function _getFormElementMultiCheckboxContent($field){
        $variableName = "$" . lcfirst($field['Field']);

        $strMultiOption = $this->_getStrMultiOptions($field['Type']);

        $arrTmp = array();

        $arrTmp[] = "$variableName = new Zend_Form_Element_MultiCheckbox('{$field['Field']}');";

        $arrTmp[] = "{$variableName}->setLabel('{$field['Field']}');";

        $arrTmp[] = "{$variableName}->setMultiOptions({$strMultiOption});";

        $arrTmp[] = $this->_getStrRequiredForElementForm($variableName, $field);

        $arrTmp[] = "{$variableName}->setDecorators(array('ViewHelper'));";

        $arrTmp[] = "\$this->addElement($variableName);\n";

        $content = implode("\n" . $this->_padding2, $arrTmp);
        return $content;
    }
    /**
     * @desc    get Element whose type is 'Radio'
     * @param array $field
     * @return string
     */
    protected function _getFormElementSelectContent($field){
        $variableName = "$" . lcfirst($field['Field']);

        $strMultiOption = $this->_getStrMultiOptions($field['Type']);
        $arrTmp = array();

        $arrTmp[] =  "$variableName = new Zend_Form_Element_Select('{$field['Field']}');";

        $arrTmp[] = "{$variableName}->setLabel('{$field['Field']}');";

        $arrTmp[] = "{$variableName}->setMultiOptions({$strMultiOption});";

        $arrTmp[] = $this->_getStrRequiredForElementForm($variableName, $field);

        $arrTmp[] = "{$variableName}->setDecorators(array('ViewHelper'));";

        $arrTmp[] = "\$this->addElement($variableName);\n";

        $content = implode("\n" . $this->_padding2, $arrTmp);
        return $content;
    }
    /**
     * @desc    get Element whose type is 'Hidden'. Nomally, The field is primary key
     * @param array $field
     * @return string
     */
    protected function _getFormElementHiddenContent($field){
        $variableName = "$" . lcfirst($field['Field']);
        $arrTmp = array();
        $arrTmp[] = "$variableName = new Zend_Form_Element_Hidden('{$field['Field']}');";

        $arrTmp[] = "{$variableName}->setDecorators(array('ViewHelper'));";

        $arrTmp[] = "\$this->addElement($variableName);\n";

        $content = implode("\n" . $this->_padding2, $arrTmp);
        return $content;
    }
    /**
     * @param array $field
     * @return string
     */
    protected function _getFormElementContent($field){

        $type = $this->_getFormElementType($field);
        switch ($type) {
            case self::FORM_ELEMENT_TEXT :
                return $this->_getFormElementTextContent($field);
            case self::FORM_ELEMENT_INT :
                return $this->_getFormElementNumberContent($field, 'Int');
            case self::FORM_ELEMENT_FLOAT :
                return $this->_getFormElementNumberContent($field, 'Float');
            case self::FORM_ELEMENT_DATE :
                return $this->_getFormElementDateContent($field);
            case self::FORM_ELEMENT_TEXTAREA :
                return $this->_getFormElementTextAreaContent($field);
            case self::FORM_ELEMENT_MULTI_CHECKBOX :
                return $this->_getFormElementMultiCheckboxContent($field);
            case self::FORM_ELEMENT_SELECT :
                return $this->_getFormElementSelectContent($field);
            case self::FORM_ELEMENT_HIDDEN :
                return $this->_getFormElementHiddenContent($field);
            default:
                self::putMsg('Form element fail');
            break;
        }
    }

    private function _getFormElementContents($fields){
        $tmpArray = array();
        foreach ($fields as $field) {
            $tmpArray[] = $this->_getFormElementContent($field);
        }
        return implode("\n" . $this->_padding2, $tmpArray);
    }

    private function _getContentForm($tableName,$fields){
        $modelTemplatePath = $this->_templatePath . '/form.template';
        $fields = $this->_getFieldsInTable($tableName);
//        Zend_Debug::dump($fields);die;
        $variables = array(
            '%%FORM_CLASS%%'            => $this->_getFormClass($tableName),
            '%%FORM_ABSTRACT_CLASS%%'   => self::FORM_ABSTRACT_CLASS,
            '%%FORM_ELEMENTS%%'         => $this->_getFormElementContents($fields),
        );

        $content = file_get_contents($modelTemplatePath);
        $content = str_replace(array_keys($variables), $variables, $content);
        return $content;
    }

    private function _getContentModel($tableName,$fields){
        $modelTemplatePath = $this->_templatePath . '/model.template';
        $fields = $this->_getFieldsInTable($tableName);
//        Zend_Debug::dump($fields);die;
        $variables = array(
            '%%MODEL_CLASS%%'            => $this->_getModelClass($tableName),
            '%%MODEL_ABSTRACT_CLASS%%'   => self::MODEL_ABSTRACT_CLASS,
            '%%TABLE_NAME%%'             => $tableName,
            '%%TABLE_FIELD_PRIMARY%%'    => $this->_getStrPrimaryKey($fields),
            '%%DEPENDENT_TABLE%%'        => '' ,
            '%%REFERENCE_MAP%%'          => '',
//            '%%DEPENDENT_TABLE%%'        => $this->_getStrDependentClasses($tableName),
//            '%%REFERENCE_MAP%%'          => $this->_getStrReferenceMap($tableName),
            '%%SEARCH_FIELDS%%'          => $this->_getSearchFields($tableName),
            '%%SORT_FIELDS%%'            => $this->_getSortFields($tableName),
        );

        $content = file_get_contents($modelTemplatePath);
        $content = str_replace(array_keys($variables), $variables, $content);
        return $content;
    }


    private function _getContentController($tableName,$fields){
        $modelTemplatePath = $this->_templatePath . '/controller.template';
        $fields = $this->_getFieldsInTable($tableName);
//        Zend_Debug::dump($fields);die;
        $variables = array(
            '%%TABLE_NAME%%'                  => $tableName,
            '%%CONTROLLER_CLASS%%'            => $this->_getControllerClass($tableName),
            '%%SHOW_ACTION%%'                 => 'show-' . $this->_camelCaseToDash($tableName),
            '%%CONTROLLER_ABSTRACT_CLASS%%'   => self::CONTROLLER_ABSTRACT_CLASS,
            '%%MODEL_CLASS%%'                 => $this->_getModelClass($tableName),
            '%%FORM_CLASS%%'                  => $this->_getFormClass($tableName),
            '%%MODEL_PRIMARY%%'               => $this->_getPrimaryKey($fields),
        );

        $content = file_get_contents($modelTemplatePath);
        $content = str_replace(array_keys($variables), $variables, $content);
        return $content;
    }



    private function _getContentViewShowAll($tableName){
        $modelTemplatePath = $this->_templatePath . '/view.show-all.template';
        $fields = $this->_getFieldsInTable($tableName);
//        Zend_Debug::dump($fields);die;
        $variables = array(
            '%%TABLE_NAME%%'                  => $tableName,
            '%%TYPE_SEARCHS%%'                => $this->_getTypeSearchs($fields),
            '%%TH_GROUP%%'                    => $this->_getThGroup($fields),
            '%%PARTIAL_PATH%%'                => $this->_getPartialFilePath($tableName),
        );

        $content = file_get_contents($modelTemplatePath);
        $content = str_replace(array_keys($variables), $variables, $content);
        return $content;
    }

    private function _getViewShowAllRecordContent($tableName){
        $modelTemplatePath = $this->_templatePath . '/view.show-all.record.template';
        $fields = $this->_getFieldsInTable($tableName);
//        Zend_Debug::dump($fields);die;
        $variables = array(
            '%%TABLE_NAME%%'                  => $tableName,
            '%%TD_GROUP%%'                    => $this->_getTdGroup($fields),
            '%%UPDATE_PATH%%'                => $this->_getUpdateLink($tableName, $fields),
            '%%DELETE_PATH%%'                => $this->_getDeleteLink($tableName, $fields),
        );

        $content = file_get_contents($modelTemplatePath);
        $content = str_replace(array_keys($variables), $variables, $content);
        return $content;
    }

    private function _getViewUpdateContent($tableName){
        $modelTemplatePath = $this->_templatePath . '/view.update.template';
        $fields = $this->_getFieldsInTable($tableName);
//        Zend_Debug::dump($fields);die;
        $variables = array(
            '%%TABLE_NAME%%'                  => $tableName,
            '%%SHOW_ALL_ACTION%%'             => "show-" . $this->_camelCaseToDash($tableName),
            '%%FORM_ELEMENTS%%'               => $this->_getFormElements($fields)
        );

        $content = file_get_contents($modelTemplatePath);
        $content = str_replace(array_keys($variables), $variables, $content);
        return $content;
    }

    private function _getViewAddContent($tableName){
        $modelTemplatePath = $this->_templatePath . '/view.add.template';
        $fields = $this->_getFieldsInTable($tableName);
//        Zend_Debug::dump($fields);die;
        $variables = array(
            '%%TABLE_NAME%%'                  => $tableName,
            '%%SHOW_ALL_ACTION%%'             => "show-" . $this->_camelCaseToDash($tableName),
            '%%FORM_ELEMENTS%%'               => $this->_getFormElements($fields)
        );

        $content = file_get_contents($modelTemplatePath);
        $content = str_replace(array_keys($variables), $variables, $content);
        return $content;
    }

    private function _getFormElements($fields){
        $tmpArr = array();
        foreach($fields as $field){
            $tmpArr[] = "<?php echo \$this->renderFormElement(\$form->{$field['Field']});?>";
        }
        return implode("\n{$this->_padding4}", $tmpArr);
    }

    private function _getTdGroup($fields){

        $tmpArr = array();
        foreach($fields as $field){
            $tmpArr[] = "\n{$this->_padding1}<td>"
                      . "\n{$this->_padding2}<?php echo \$dataRow->{$field['Field']};?>"
                      . "\n{$this->_padding1}</td>";
        }
        return implode("\n", $tmpArr);
    }

    private function _getUpdateLink($tableName, $fields){
        $viewDirName = $this->_camelCaseToDash($tableName);
        $primaryField = $this->_getPrimaryKey($fields);
        $t = "/$viewDirName/update-$viewDirName/id/<?php echo \$dataRow->{$primaryField}; ?>";
        return $t;
    }

    private function _getDeleteLink($tableName, $fields){
        $viewDirName = $this->_camelCaseToDash($tableName);
        $primaryField = $this->_getPrimaryKey($fields);
        $t = "/$viewDirName/delete-$viewDirName/id/<?php echo \$dataRow->{$primaryField}; ?>";
        return $t;
    }






    private function _getPartialFilePath($tableName){
        $t = $this->_camelCaseToDash($tableName) . '/_partial/' . $this->_getViewShowAllFileName($tableName);
        return $t;
    }

    private function _getThGroup($fields){
        $tmpArr = array();
        foreach($fields as $field){
            $tmpArr[] = "<?php \$this->renderTh('{$field['Field']}'); ?>";
        }
        return implode("\n{$this->_padding5}", $tmpArr);
    }

    private function _getTypeSearchs($fields){
        $tmpArr = array();
        foreach($fields as $field){
            $t = str_pad("'{$field['Field']}'",30);
            $tmpArr[] = "{$t} => \$this->text('{$field['Field']}', false),";
        }
        return implode("\n{$this->_padding1}", $tmpArr);
    }

    /**
     * getPrimaryKey from table fields
     *
     * @param array $fields
     * @return string
     */
    protected function _getStrPrimaryKey($fields){
        $priKeys = "array(";
        foreach($fields as $field){
            if($field['Key'] == "PRI"){
                $priKeys .= "'{$field['Field']}',";
            }
        }
        $priKeys .= ")";
        return $priKeys;
    }

    protected function _getPrimaryKey($fields){

        foreach($fields as $field){
            if($field['Key'] == "PRI"){
                return $field['Field'];
            }
        }

        return null;
    }

    private function _getSearchFields($tableName){
        $fields = $this->_getFieldsInTable($tableName);
        $tmpArr = array();
        foreach($fields as $field){
            $tmpArr[] = $this->_getStrSearchFieldItem($tableName, $field);
        }
        $glue = "\n{$this->_padding3}";
        $result = implode($glue, $tmpArr);
        return $result;
    }

    private function _getSortFields($tableName){
        $fields = $this->_getFieldsInTable($tableName);
        $tmpArr = array();
        foreach($fields as $field){
            $tmpArr[] = $this->_getStrSortFieldItem($tableName, $field);
        }
        $glue = "\n{$this->_padding3}";
        $result = implode($glue, $tmpArr);
        return $result;
    }

    private function _getStrSortFieldItem($tableName, $field){
        $param = str_pad("\"{$field['Field']}_Sort\"", 30);
        $tableField = str_pad($tableName . '.' . $field['Field'], 30);

        $t = "{$param} => \"$tableField {{param}}\",";

        return $t;
    }

    private function _getStrSearchFieldItem($tableName, $field){
        $param = str_pad("\"{$field['Field']}\"", 30);
        $tableField = str_pad("{$tableName}.{$field['Field']}", 30);

        switch ($this->_getFormElementType($field)) {
            case self::FORM_ELEMENT_INT:
            case self::FORM_ELEMENT_HIDDEN:
            case self::FORM_ELEMENT_DATE:
            case self::FORM_ELEMENT_FLOAT:
                $t = "{$param} => \"$tableField = '{{param}}'\",";
                break;
            case self::FORM_ELEMENT_MULTI_CHECKBOX:
            case self::FORM_ELEMENT_SELECT:
            case self::FORM_ELEMENT_TEXT:
            case self::FORM_ELEMENT_TEXTAREA:
                $t = "{$param} => \"{$tableField} LIKE '%{{param}}%'\",";
            break;

            default:
                ;
            break;
        }
        return $t;
    }
    /**
     * @param string $tableName
     * @return array: table referenced $tableName. So return array item is unique (Distinct)
     */
    private function _getReferencedTableNames($tableName){
        if(!isset($this->_mapTables[$tableName])){

            $sql = "SELECT DISTINCT KEY_COLUMN_USAGE.REFERENCED_TABLE_NAME
                    FROM TABLE_CONSTRAINTS
                    INNER JOIN KEY_COLUMN_USAGE
                      ON TABLE_CONSTRAINTS.CONSTRAINT_NAME = KEY_COLUMN_USAGE.CONSTRAINT_NAME
                        AND TABLE_CONSTRAINTS.TABLE_SCHEMA = KEY_COLUMN_USAGE.CONSTRAINT_SCHEMA
                    WHERE TABLE_CONSTRAINTS.TABLE_SCHEMA = '{$this->_configs['DatabaseName']}'
                      AND TABLE_CONSTRAINTS.CONSTRAINT_TYPE = 'FOREIGN KEY'
                      AND KEY_COLUMN_USAGE.TABLE_NAME = '$tableName'";

            $this->_mapTables[$tableName] = $this->_schemaDb->fetchCol($sql);
        }
//        Zend_Debug::dump($tables);die;
        return $this->_mapTables[$tableName];
    }

    /**
     * This function called from getStrDependentClasses
     * @param string $tableName
     * @return multitype:
     */
    private function _getDependentTables($tableName){
        if(!isset($this->_defendentTables[$tableName])){

            $sql = "SELECT TABLE_CONSTRAINTS.TABLE_NAME
                    FROM TABLE_CONSTRAINTS
                    INNER JOIN REFERENTIAL_CONSTRAINTS
                      ON TABLE_CONSTRAINTS.CONSTRAINT_NAME = REFERENTIAL_CONSTRAINTS.CONSTRAINT_NAME
                        AND TABLE_CONSTRAINTS.CONSTRAINT_SCHEMA = REFERENTIAL_CONSTRAINTS.CONSTRAINT_SCHEMA
                    WHERE TABLE_CONSTRAINTS.TABLE_SCHEMA = '{$this->_configs['DatabaseName']}'
                      AND TABLE_CONSTRAINTS.CONSTRAINT_TYPE = 'FOREIGN KEY'
                      AND REFERENTIAL_CONSTRAINTS.REFERENCED_TABLE_NAME = '$tableName'";
    //        die('<pre>' .$sql);

            $this->_defendentTables[$tableName] = $this->_schemaDb->fetchCol($sql);
        }
//        Zend_Debug::dump($tables);die;
        return $this->_defendentTables[$tableName];
    }



    /**
     * @param string $tableName
     * @param string $referencedTableName
     * @return string
     */
    private function _getStrReferenceItem($tableName, $referencedTableName){
        $foreignKeyCols  = $this->_getForeignKeyInfos($tableName, $referencedTableName);
        $strResult = '';
        foreach($foreignKeyCols as $foreignKeyCol){
            $strResult  .= "\n";
            $strResult  .= "        '{$referencedTableName}.{$foreignKeyCol['COLUMN_NAME']}' => array(\n";
            $strResult  .= "            'columns'        => '" .
                                            $foreignKeyCol['COLUMN_NAME'] . "',\n";
            $strResult  .= "            'refTableClass'  => '" .
                                            $this->_getModelClass($referencedTableName) . "',\n";
            $strResult  .= "            'refColumns'     => '" .
                                            $foreignKeyCol['REFERENCED_COLUMN_NAME'] . "',\n";
            $strResult  .= '        ),';
        }
        return $strResult;
    }

    /**
     * @param string $tableName
     * @return string
     */
    private function _getStrDependentClasses($tableName){
        $strDependentClasses='';
        $dependentTables = $this->_getDependentTables($tableName);
        foreach($dependentTables as $key => $table){
            $dependentTables[$key] = "        '" . $this->_getModelClass($table) . "'";
        }

        $strDependentClasses = implode(",\n",$dependentTables);
        return $strDependentClasses;
    }
    /**
     * @desc    get all table names in DB
     */
    protected function _getTableNames(){
        if(!isset($this->_tableNames)){
            $sql = 'SHOW TABLES';
            $this->_tableNames = $this->_db->fetchCol($sql);
        }
        return $this->_tableNames;
    }

    /**
     * @desc    get all fields in table named tableName
     */
    protected function _getFieldsInTable($tableName){

        if(!isset($this->_fields[$tableName])){
            $sql = "SHOW COLUMNS FROM `{$tableName}`";
            $this->_fields[$tableName] = $this->_db->fetchAll($sql);
//            Zend_Debug::dump($fields);die;
        }
        return $this->_fields[$tableName];
    }

    public static function putMsg($string){
        self::$messages[] = $string;
    }
    public static function getMsg(){
        $glue = "\n";
        $t ='';
        if(count(self::$messages)){
            $t = '<pre>' .implode($glue, self::$messages) . '</pre>';
        }
        return $t;
    }


    /**
     * @desc    create directory and set mod 0777 for all sub dir of it
     * @param   string $dirPath
     */
    protected function _createDirStructure($dirPath){
        if(!file_exists($dirPath)){
            mkdir($dirPath, 0744, true) or die('cannot create dir');
        }
    }


    /**
     * @desc create File
     * @param string $objectDirName,    ex: 'models', 'forms', 'models/DbTable'
     * @param string $tableName,        ex: 'Videos', 'AdClips'
     * @param string $content
     */
    protected function _createFile($dirPath, $fileName, $content){

        $filePath = $dirPath . '/' . $fileName;

        if(file_exists($filePath)){
            self::putMsg("file existed: $filePath");
            return;
        }

        //open file for write
        $fp = fopen($filePath, 'w');
        if(!$fp){
            self::putMsg("Can't open file: $filePath");
            return;
        }
        /*set mod for file */
        $setMod = chmod($filePath, 0777);
        if(!$setMod){
            self::putMsg("Can't set chmod file: $filePath");
            return;
        }
        //write file

        $fw = fwrite($fp, $content);
        if(!$fw){
            self::putMsg("Can't set chmod file: $filePath");
            return;
        }
        fclose($fp);


        self::putMsg("Create file success : $filePath");
        return true;
    }

    private function _getModelClass($tableName){
        $t = 'Application_Model_' . $this->_configs['Schema'] . "_$tableName";
        return $t;
    }

    private function _getControllerClass($tableName){
        $t = "{$tableName}Controller";
        return $t;
    }

    private function _getFormClass($tableName){
        $t = 'Application_Form_' . $this->_configs['Schema'] . "_$tableName";
        return $t;
    }
}