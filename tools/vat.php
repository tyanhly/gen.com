<?php
    /**
     * Tool for generate application built for Zend Framework Projects
     * Current function:
     *      Build model and form for using in project
     *
     *      Create model and form extend from built model and form
     *
     *      Create test cases and files for insert update and show all
     *
     * Command Example:
     *      create model:       sh vat create model
     *      create form:        sh vat create form
     *      create controller   sh vat create controller
     *      create view         sh vat create view
     *      create all:         sh vat create all
     *          (create all will create model, form, controller, view, but not test)
     *
     *      create test         sh vat create test
     *
     *      build model:        sh vat build model
     *      build form:         sh vat build form
     *      build all:          sh vat build all
     * @package:    Base core
     * @subpackage: Tool
     * @author:     Ly Tung
     */

    class Generator {

        const ENVIRONMENT                   = 'development : production';

        const APPLICATION_DIR               = '../application';
        const BUILD_DIR_NAME                = 'Skeleton';
        const TEST_CONTROLLER_NAME          = 'SkeletonTest';

        const CONFIG_FILE_PATH              = '../application/configs/application.ini';

        const PARENT_MODEL_CLASS            = 'Zend_Db_Table';
        const PARENT_FORM_CLASS             = 'Zend_Form';
        const PARENT_CONTROLLER_CLASS       = 'Base_Controller_Action';

        const FORM_ELEMENT_TEXT             = 'text';
        const FORM_ELEMENT_INT              = 'int';
        const FORM_ELEMENT_FLOAT            = 'float';
        const FORM_ELEMENT_DATE             = 'date';
        const FORM_ELEMENT_TEXTAREA         = 'textarea';
        const FORM_ELEMENT_MULTI_CHECKBOX   = 'checkbox';
        const FORM_ELEMENT_SELECT           = 'radio';
        const FORM_ELEMENT_HIDDEN           = 'hidden';
        const FORM_ELEMENT_SUBMIT           = 'submit';

        const PADDING_DISTANCE              = '    ';

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


        /**
         * @var string
         * @desc db Name
         */
        protected $_dbName = 'MyTable';
        /**
         * @var string
         * @desc db user name
         */
        protected $_username = 'developer';
        /**
         * @var string
         * @desc db user password
         */
        protected $_password = 'workaholic';
        /**
         * @var string
         * @desc db host
         */
        protected $_host = '192.168.11.1';
        /**
         * @var string
         * @desc db adapter
         */
        protected $_adapter = 'PDO_MYSQL';
        /**
         * @var string
         * @desc module name. if module name = 'application' then 'modules directory is not created
         */
        protected $_moduleName = 'application';

        /**
         * @var string
         * @desc db connect object
         */
        protected $_connect;

        public function Generator(){
           $this->_setOption();
        }
        /**
         * This function will read ini file and assign value for $this's variable
         *
         * Ex:
         *   [development : production]
         *   resources.db.adapter = PDO_MYSQL
         *   resources.db.params.host = localhost
         *   resources.db.params.username = root
         *   resources.db.params.password = 123456
         *   resources.db.params.dbname = vapedia
         *
         */
        protected function _setOption(){
            $configs = parse_ini_file(self::CONFIG_FILE_PATH, true);

            $this->_adapter =
                $configs[self::ENVIRONMENT]['resources.db.adapter'];
//            var_dump($this->_adapter);die();
            $this->_host =
                $configs[self::ENVIRONMENT]['resources.db.params.host'];
            $this->_username =
                $configs[self::ENVIRONMENT]['resources.db.params.username'];
            $this->_password =
                $configs[self::ENVIRONMENT]['resources.db.params.password'];
            $this->_dbName =
                $configs[self::ENVIRONMENT]['resources.db.params.dbname'];
//            var_dump($this);die();
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
                 Color::output( 'Error write file: '.
                                realpath($filePath) .
                                '.Beacause, file existed','red');
                return;
            }

            //open file for write
            $fp = fopen($filePath, 'w');
            if(!$fp){
                Color::output("Can't open file",'red');
                die();
            }
            /*set mod for file */
            $setMod = chmod($filePath, 0777);
            if(!$setMod){
                Color::output('cannot set chmod','red');
                die();
            }
            //write file

            $fw = fwrite($fp, $content);
            if(!$fw){
                Color::output('cannot set chmod','red');
                die();
            }
            fclose($fp);

            Color::output(realpath($filePath), 'white');
        }

        /**
         * @desc    create directory and set mod 0777 for all sub dir of it
         * @param   string $dirPath
         */
        protected function _createDirStructure($dirPath){

            if(!file_exists($dirPath)){
                mkdir($dirPath, 0777, true) or die('cannot create dir');

                //set mod for dir hierachy
                $dirs = explode('/', $dirPath);
                $tmpDir='';

                foreach($dirs as $dir){
                    $tmpDir .= $dir;
                    chmod($tmpDir,0777) or die('cannot set chmod');
                    $tmpDir .= '/';
                }

            }
        }

        /**
         * @return string uppercase
         */
        protected function _getNamespace(){
            return ucfirst($this->_moduleName);
        }

        /**
         * @desc    Connect and Select DB, if $dbName is NULL. then db name = $this->_dbName
         * @param   $dbName
         */
        protected function _connectDb($dbName=NULL){
            //ket noi csdl mysql
            if(!$this->_connect)
                $this->_connect = mysql_connect($this->_host, $this->_username, $this->_password);
            if (!$this->_connect) {
                die('Could not connect: ' . mysql_error());
            }
            if($dbName == NULL){
                //chon database
                $db_selected = mysql_select_db($this->_dbName, $this->_connect);
                if (!$db_selected) {
                    die ('Can\'t use foo : ' . mysql_error());
                }
            }else {
                $db_selected = mysql_select_db($dbName, $this->_connect);
                if (!$db_selected) {
                    die ('Can\'t use foo : ' . mysql_error());
                }
            }
        }
        /**
         * @desc    get all table names in DB
         */
        protected function _getTableNames(){
            $result = mysql_list_tables($this->_dbName);
            $num_rows = mysql_num_rows($result);
            $names = array();

            for ($i = 0; $i < $num_rows; $i++) {
                $names[$i]= mysql_tablename($result, $i);
            }
            return $names;
        }
        /**
         * @desc    get all fields in table named tableName
         */
        protected function _getFieldsInTable($tableName){

            $sql = "SHOW COLUMNS FROM {$tableName}";
            $result = mysql_query($sql);
            $fields = array();
            if (mysql_num_rows($result) > 0) {
                while (true == ($tmp = mysql_fetch_assoc($result))){
                    $fields[] = $tmp;
                }
            }
            return $fields;
        }
        /**
         * @desc    get list column of all Table w
         */
        protected function _getColumnsOfAllTables(){
            $this->_connectDb();
            $tableNames = $this->_getTableNames();
            $tables = array();

            foreach ($tableNames as $tableName){
                $index = 0;
                $tables[substr($tableName,$index,strlen($tableName)-$index)] = $this->_getFieldsInTable($tableName);
            }

            return $tables;
        }
        /*
         * close connect DB
         */
        protected function _close(){
            mysql_close($this->_connect);
        }

        /**
         * getCommand for file
         *
         * @param array $fields
         * @return string
         * @todo insert data for @desc
         */
        protected function _getStrDescriptionFile(){

        return  <<<EOT

/**
 * @desc
 * @category
 * @package:
 * @subpackage:
 * @version:
 * @author:
 *
 */

EOT;
        }

        /**
         * getPrimaryKey from table fields
         *
         * @param array $fields
         * @return string
         */
        protected function _getStrPrimaryKey($fields){
            $priKeys = "array(";
            foreach($fields as $fields){
                if($fields['Key'] == "PRI"){
                    $priKeys .= "'{$fields['Field']}',";
                }
            }
            $priKeys .= ")";
            return $priKeys;
        }

        protected function _getPrimaryKey($fields){

            $priKeys = array();
            foreach($fields as $field){
                if($field['Key'] == "PRI"){
                    $priKeys[] = $field['Field'];
                }
            }
            return $priKeys;
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
                    Color::output('Error about element type', 'red');
                break;
            }
        }
        /**
         * @desc this function is used in _getFormElement<type>Content
         * @param string $variableName
         * @param array $field
         * @return string|string
         */
        protected function _getStrRequiredForElementForm($variableName, $field){
//            var_dump($field['Null']);
            if($field['Null']=='NO'){
//                var_dump($field['Null']);
                return "{$variableName}->setRequired(true);";
            }
            return '';
        }

    /**
         * @desc    This function is used in createViewFiles
         *          Function: Convert capitalize char ('A - Z') to ('-' . 'a-z')
         *          EX: AdClipPlaylists => adclip-playlists
         * @param string strController
         */
        protected function _getStrViewDirOfController($strController){
            //
            $startPos    = 0;
            $arrTmp = array();
            /**
             * Ex: We has table, AdClipPlaylist.
             * This code will assign $arrTmp = array(adClip-playlists)
             */
            for($i = 1; $i < strlen($strController); $i++){
                if((ord($strController[$i]) >= 65) && (ord($strController[$i]) <= 91)){
//                    echo ord($strController[$i]) . "\n";
                    $arrTmp[] = substr($strController, $startPos, $i - $startPos);
                    $startPos = $i;
                }
            }
            $arrTmp[] = substr($strController, $startPos, $i - $startPos);

            $result = strtolower(implode('-', $arrTmp));
//            echo $result ."\n";
            return $result;
        }
        /**
         * @desc    This function is used in createViewFiles
         *          Function: Convert capitalize char ('A - Z') to ('-' . 'a-z')
         *          EX: AdClipPlaylists => adclip-playlists
         * @param string strController
         */
        protected function _getStrViewDirOfName($strController){
            //
            $startPos    = 0;
            $arrTmp = array();
            /**
             * Ex: We has table, AdClipPlaylist.
             * This code will assign $arrTmp = array(adClip-playlists)
             */
            for($i = 1; $i < strlen($strController); $i++){
                if((ord($strController[$i]) >= 65) && (ord($strController[$i]) <= 91)){
//                    echo ord($strController[$i]) . "\n";
                    $arrTmp[] = substr($strController, $startPos, $i - $startPos);
                    $startPos = $i;
                }
            }
            $arrTmp[] = substr($strController, $startPos, $i - $startPos);

            $result = strtolower(implode(' ', $arrTmp));
//            echo $result ."\n";
            return $result;
        }
        /**
         * @desc    get Element whose type is 'Text'
         * @param array $field
         * @return string
         */
        protected function _getFormElementTextContent($field){
            $variableName = '$elements["'. $field['Field'] .'"]';
            $arrTmp = array();


            $arrTmp[] = self::PADDING_DISTANCE . self::PADDING_DISTANCE .
                "$variableName = new Zend_Form_Element_Text('{$field['Field']}');";

            $arrTmp[] = "{$variableName}->setLabel('{$field['Field']}');";

            $arrTmp[] = "{$variableName}->addFilter('StringTrim');";

            $arrTmp[] = $this->_getStrRequiredForElementForm($variableName, $field);

            $content = implode("\n" . self::PADDING_DISTANCE . self::PADDING_DISTANCE, $arrTmp);
            return $content;

        }
        /**
         * @desc    get Element whose type is 'Number'
         * @param array $field
         * @param string $type
         * @return string
         */
        protected function _getFormElementNumberContent($field, $type = 'Int'){
            $variableName = '$elements["'. $field['Field'] .'"]';
            $arrTmp = array();
//            Zend_Validate_Int Zend_Validate_Float
            $arrTmp[] = self::PADDING_DISTANCE . self::PADDING_DISTANCE .
                "$variableName = new Zend_Form_Element_Text('{$field['Field']}');";

            $arrTmp[] = "{$variableName}->setLabel('{$field['Field']}');";

            $arrTmp[] = "{$variableName}->addFilter('StringTrim');";

            $arrTmp[] = "{$variableName}->addValidator('{$type}');";

            $arrTmp[] = $this->_getStrRequiredForElementForm($variableName, $field);

            $content = implode("\n" . self::PADDING_DISTANCE . self::PADDING_DISTANCE, $arrTmp);
            return $content;

        }

        /**
         * @desc    get Element whose type is 'Date'
         * @param array $field
         * @return string
         */
        protected function _getFormElementDateContent($field){
            $variableName = '$elements["'. $field['Field'] .'"]';
            $arrTmp = array();
//            Zend_Validate_Int Zend_Validate_Float
            $arrTmp[] = self::PADDING_DISTANCE . self::PADDING_DISTANCE .
                "$variableName = new Zend_Form_Element_Text('{$field['Field']}');";

            $arrTmp[] = "{$variableName}->setLabel('{$field['Field']}');";

            $arrTmp[] = "{$variableName}->addFilter('StringTrim');";

            $arrTmp[] = "{$variableName}->addValidator('Date');";

            $arrTmp[] = $this->_getStrRequiredForElementForm($variableName, $field);

            $content = implode("\n" . self::PADDING_DISTANCE . self::PADDING_DISTANCE, $arrTmp);
            return $content;

        }

        /**
         * @desc    get Element whose type is 'TextArea'
         * @param array $field
         * @return string
         */
        protected function _getFormElementTextAreaContent($field){
            $variableName = '$elements["'. $field['Field'] .'"]';
            $arrTmp = array();

            $arrTmp[] = self::PADDING_DISTANCE . self::PADDING_DISTANCE .
                 "$variableName = new Zend_Form_Element_Textarea('{$field['Field']}');";
            $arrTmp[] = "{$variableName}->setLabel('{$field['Field']}');";
            $arrTmp[] = $this->_getStrRequiredForElementForm($variableName, $field);

            $content = implode("\n"  . self::PADDING_DISTANCE . self::PADDING_DISTANCE, $arrTmp);
            return $content;
        }
        /**
         * @desc    get Element whose type is 'set'('MultiCheckbox')
         * @param array $field
         * @return string
         */
        protected function _getFormElementMultiCheckboxContent($field){
            $variableName = '$elements["'. $field['Field'] .'"]';

            $strMultiOption = $this->_getStrMultiOptions($field['Type']);

            $arrTmp = array();

            $arrTmp[] = self::PADDING_DISTANCE . self::PADDING_DISTANCE .
                "$variableName = new Zend_Form_Element_MultiCheckbox('{$field['Field']}');";

            $arrTmp[] = "{$variableName}->setLabel('{$field['Field']}');";

            $arrTmp[] = "{$variableName}->setMultiOptions({$strMultiOption});";

            $arrTmp[] = $this->_getStrRequiredForElementForm($variableName, $field);

            $content = implode("\n" . self::PADDING_DISTANCE . self::PADDING_DISTANCE, $arrTmp);
            return $content;
        }
        /**
         * @desc    get Element whose type is 'Radio'
         * @param array $field
         * @return string
         */
        protected function _getFormElementSelectContent($field){
            $variableName = '$elements["'. $field['Field'] .'"]';

             $strMultiOption = $this->_getStrMultiOptions($field['Type']);
//             var_dump($strMultiOption);die();
            $arrTmp = array();

            $arrTmp[] = self::PADDING_DISTANCE . self::PADDING_DISTANCE .
                 "$variableName = new Zend_Form_Element_Select('{$field['Field']}');";

            $arrTmp[] = "{$variableName}->setLabel('{$field['Field']}');";

            $arrTmp[] = "{$variableName}->setMultiOptions({$strMultiOption});";

            $arrTmp[] = $this->_getStrRequiredForElementForm($variableName, $field);

            $content = implode("\n" . self::PADDING_DISTANCE . self::PADDING_DISTANCE, $arrTmp);
            return $content;
        }
        /**
         * @desc    get Element whose type is 'Hidden'. Nomally, The field is primary key
         * @param array $field
         * @return string
         */
        protected function _getFormElementHiddenContent($field){
            $variableName = '$elements["'. $field['Field'] .'"]';
            $arrTmp = array();
            $arrTmp[] = self::PADDING_DISTANCE . self::PADDING_DISTANCE .
                "$variableName = new Zend_Form_Element_Hidden('{$field['Field']}');";
//            $arrTmp[] = $this->_getStrRequiredForElementForm($variableName, $field);

            $content = implode("\n" . self::PADDING_DISTANCE . self::PADDING_DISTANCE, $arrTmp);
            return $content;
        }
        /*
         * get Content Model for table which name =$tableName and data
         *
         * @param string $tableName
         * @param array $fields
         * @return string
         */
        protected function _getModelContent($tableName, $fields){
            $tableName = ucfirst($tableName);
            $modelClass = $this->_getNamespace() . '_Model_DbTable_'. $tableName;
            $parentClass = self::PARENT_MODEL_CLASS;

            $pri = $this->_getStrPrimaryKey($fields);

            $arrTmp[] = "<?php\n";
            $arrTmp[] = $this->_getStrDescriptionFile();
            $arrTmp[] = "class {$modelClass} extends $parentClass { \n";
            $arrTmp[] = self::PADDING_DISTANCE .
                        "protected \$_name =  '{$tableName}';";
            $arrTmp[] = self::PADDING_DISTANCE .
                        "protected \$_primary  = {$pri};\n";

            $arrTmp[] = self::PADDING_DISTANCE .
                        "protected \$_dependentTables = array(";

            $arrTmp[] = $this->getStrDependentClasses($tableName);

            $arrTmp[] = self::PADDING_DISTANCE . "); \n";

            $arrTmp[] = self::PADDING_DISTANCE .
                        "protected \$_referenceMap = array(";

            $arrTmp[] = self::PADDING_DISTANCE .
                        $this->getStrReferenceMap($tableName);

            $arrTmp[] = self::PADDING_DISTANCE . "); \n";
            $arrTmp[] = "}";

            $content = implode("\n", $arrTmp);
//            echo $content; die();
            return $content;
        }

        /**
         *
         * @desc get form content
         * @param string $tableName
         * @param array $fields
         * @return string
         */
        protected function _getFormContent($tableName, $fields){
            $tableName = ucfirst($tableName);
            $className = $this->_getNamespace() . '_Form_'. $tableName;
            $arrTmp = array();
            $arrTmp[] = "<?php";
            $arrTmp[] = $this->_getStrDescriptionFile();
            $arrTmp[] = "class {$className} extends " . self::PARENT_FORM_CLASS . " { ";

            $arrTmp[] = self::PADDING_DISTANCE .
                        "protected \$_formType = 'Add';";

            $arrTmp[] = self::PADDING_DISTANCE .
                        "public function __construct(\$options = null) {";
            //construct function
            $arrTmp[] = self::PADDING_DISTANCE . self::PADDING_DISTANCE .
                        "parent::__construct(\$options);" .
                        "\n" .self::PADDING_DISTANCE . self::PADDING_DISTANCE .
                        '$this->setMethod("post");'.
                        "\n" .self::PADDING_DISTANCE . self::PADDING_DISTANCE .
                        '$this->setMethod("id", "'.$tableName.'-Form");'.
                        "\n" .self::PADDING_DISTANCE . self::PADDING_DISTANCE .
                        '$this->setAttrib("class", "'.$tableName.'-Form");';

            $arrTmp[] = self::PADDING_DISTANCE . self::PADDING_DISTANCE .
                        "\$elements = array();";
//            echo 'dfdf'; die();
            foreach($fields as $field){
                $arrTmp[] = "\n" . $this->_getFormElementContent($field);
            }

//            $arrTmp[] = "\n" . self::PADDING_DISTANCE . self::PADDING_DISTANCE
//                      . '$elements[\'submit\'] = Zend_Form_Element_Submit(\'Submit\');';

            $arrTmp[] = "\n" . self::PADDING_DISTANCE . self::PADDING_DISTANCE .
                        '$this->addElements($elements);';

            $arrTmp[] = "\n" . self::PADDING_DISTANCE . self::PADDING_DISTANCE .
                        '$this->decorator();';
            
            $arrTmp[] = self::PADDING_DISTANCE . "}";

            $arrTmp[] = "}";
            $content = implode("\n", $arrTmp);
//            echo $content; die();
            return $content;
        }

        /**
         *
         * @desc get controller content
         * @param string $tableName
         * @param array $fields
         * @return string
         */
        protected function _getControllerContent($tableName, $fields){
            $tableName = ucfirst($tableName);
            $class = $tableName . 'Controller';
            $namespace = $this->_getNamespace();
            $pClass = self::PARENT_CONTROLLER_CLASS;

            $primaryKey = $this->_getPrimaryKey($fields);

            /*
             * set statement removeElement
             */
            $strRemoveElements =array();
            foreach($primaryKey as $fieldKey){
                $strRemoveElements[] = "\$form->removeElement('$fieldKey');";
            }
            $strRemoveElements = implode("\n        ", $strRemoveElements);
            $content = <<<EOT
<?php
{$this->_getStrDescriptionFile()}
class {$class} extends {$pClass}{
    /** @var {$namespace}_Model_{$tableName} */
    protected \$_model;
    public function init(){
        \$this->_model = new {$namespace}_Model_{$tableName}();
    }

    public function addAction(){
        \$form = new {$namespace}_Form_{$tableName}();

        //$strRemoveElements
        if(\$this->_request->isPost()) {
            \$data = \$this->_request->getPost();
            if (\$form->isValid(\$data)) {
                \$this->_model->add(\$form->getValues());
                \$this->_helper->redirector('show-all');
            }
        }

        \$this->view->form = \$form;

    }

    public function editAction(){
        \$form = new {$namespace}_Form_{$tableName}();

        if(\$this->_request->isPost()) {
            \$data = \$this->_request->getPost();
            if (\$form->isValid(\$data)) {
                \$this->_model->update(\$form->getValues());
                \$this->_helper->redirector('show-all');
            }
        }
        \$primary = \$this->_request->getParam("primary");
        \$data = \$this->_model->fetchRow(\$primary)->toArray();
        \$form->getElement('submit')->setLabel('Update');
        \$form->populate(\$data);

        \$this->view->form = \$form;
    }

    public function showAllAction(){
        \$this->view->rows = \$this->_model->fetchAll();
    }
}
EOT;
//            die($content);
            return $content;
        }
     /**
         * @param string $tableName
         * @return string
         */
        protected function _getAddViewContent($tableName){
            $name = $this->_getStrViewDirOfController($tableName);
            return <<<EOT
<?php echo \$this->renderBlock('add-$name', \$this); ?>

EOT;
        }
    /**
         * @param string $tableName
         * @return string
         */
        protected function _getAddViewContentBlock($tableName){
            $title = $this->_getStrViewDirOfName($tableName);
            $name = $this->_getStrViewDirOfController($tableName);
            return <<<EOT
    <?php \$storage = new Zend_Session_Namespace(SESSION_RETURN_BACK);?>
    <div class="simple-form ">
      <div class="title-box">
        <div class="title-name">Add new $title</div>
        <div class="title-img"></div>
      </div>
      <div class="content-simple-form border">
        <!--Jquery  Accordion -->
        <div id="accordion">
          <div >
            <div class="simple-form-fieldset">
              <h2 class="icon-delete"><?php echo \$this->error ?></h2>
              <div>
                <?php echo \$this->renderBlock('form-$name', \$this); ?>
                <tr class="<?php echo FORM_TR_CLASS ?>">
                    <td colspan="2">
                        <a class="<?php echo FORM_BUTTON_CANCEL_CLASS ?>" href="#" target="_blank">Cancel</a>
                        <a class="<?php echo FORM_BUTTON_RESET_CLASS ?>" href="#" target="_blank">Reset</a>                        
                        <a class="<?php echo FORM_BUTTON_SAVE_CLASS ?>" href="#" target="_blank">Save</a>                        
                     </td>
                </tr>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
    <script type="text/javascript">
        $('.btn_green').click(function () {
            $('.btn.green').attr('disabled','disabled');
            $('.$tableName-Form').submit();
        });
        $('.btn.red').click(function () {
            window.location.href = '<?php echo \$storage->url ?>';
        });
        $('.btn.blue').click(function () {
            document.getElementById('$tableName-Form').reset();
        });
    </script>
EOT;
        }
        /**
         * @param string $tableName
         * @return string
         */
        protected function _getUpdateViewContent($tableName){
            $name = $this->_getStrViewDirOfController($tableName);
            return <<<EOT
<?php echo \$this->renderBlock('update-$name', \$this); ?>

EOT;
        }
            /**
         * @param string $tableName
         * @return string
         */
        protected function _getUpdateViewContentBlock($tableName){
            $title = $this->_getStrViewDirOfName($tableName);
            $name = $this->_getStrViewDirOfController($tableName);
            return <<<EOT
    <div class="simple-form ">
      <div class="title-box">
        <div class="title-name">Update $title</div>
        <div class="title-img"></div>
      </div>
      <div class="content-simple-form border">
        <!--Jquery  Accordion -->
        <div id="accordion">
          <div >
            <div class="simple-form-fieldset">
              <h2 class="icon-delete"><?php echo \$this->error ?></h2>
              <div>
                <?php echo \$this->renderBlock('form-$name', \$this); ?>
                <tr class="<?php echo FORM_TR_CLASS ?>">
                    <td colspan="2">
                        <a class="<?php echo FORM_BUTTON_CANCEL_CLASS ?>" href="#" target="_blank">Cancel</a>
                        <a class="<?php echo FORM_BUTTON_RESET_CLASS ?>" href="#" target="_blank">Reset</a>                        
                        <a class="<?php echo FORM_BUTTON_SAVE_CLASS ?>" href="#" target="_blank">Save</a>                        
                     </td>
                </tr>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
    <script type="text/javascript">
        $('.btn_green').click(function () {
            $('.btn.green').attr('disabled','disabled');
            $('.$tableName-Form').submit();
        });
        $('.btn.red').click(function () {
            window.location.href = '<?php echo \$storage->url ?>';
        });
        $('.btn.blue').click(function () {
            document.getElementById('$tableName-Form').reset();
        });
    </script>
EOT;
        }
    /**
         * @param string $tableName
         * @return string
         */
        protected function _getShowAllViewContent($tableName){
            $name = $this->_getStrViewDirOfController($tableName);
            return <<<EOT
<?php echo \$this->renderBlock('show-all-$name', \$this); ?>

EOT;
        }
        /**
         * @param string $tableName
         * @return string
         */
        protected function _getFormViewContentBlock($tableName){
            return <<<EOT
<?php echo \$this->form; ?>

EOT;
        }
        /**
         * @param string $tableName
         * @return string
         */
        protected function _getSearchViewContentBlock($tableName, $fields){
            $name = $this->_getStrViewDirOfController($tableName);
            
            $primaryKey = $this->_getPrimaryKey($fields);
            $params = array();
            foreach($primaryKey as $fieldKey){
                $pri = $fieldKey;
                $params[] = "$fieldKey=<?php echo \$this->$fieldKey; ?>";
            }
            $params = implode("&", $params);
            $viewFieldsTmp = array();
            $viewFirstFieldTmp = "";
            foreach($fields as $field){
                $title = ucwords($this->_getStrViewDirOfName($field['Field']));
                if($pri!=$field['Field'] && $field['Field']!='IsInvisible')
                $viewFieldsTmp[] = "<option value='{$field['Field']}' <?php echo (\$this->typeSearch == '{$field['Field']}') ? 'selected' : ''; ?>>$title</option>";
            }

            $viewFieldsTmp = implode("\n                    ",$viewFieldsTmp);
            $action = '/' . $this->_getStrViewDirOfController($tableName)
                    . '/show-all';
            return <<<EOT
    <div class="block-border">
        <div class="form" style="float:left;">
            <form action="$action" id="$name-form">
                <span class="small">Search for:</span>
                    <input type="text"  name="keyWord" id="keyWord" class="small" value="<?php echo \$this->keyWord;?>">
                <span class="small">in</span>
                <select name="typeSearch" id="typeSearch" class="small">
                    <option value="all" <?php echo (\$this->typeSearch == 'all') ? "selected" : ""; ?>>All</option>
                    $viewFieldsTmp
                </select>

                <button type="submit" id="search-command" class="submits">Search</button>
                <button type="reset">Clear</button>
            </form>
        </div>

        <div class="float-right">
            <button type="button" class="red butDelete"><div class="images-icons-fugue-cross-circle"></div> Delete</button>
            <button type="button" class="butAdd">Add</button>
        </div>

        <div style="clear:both;"></div>


    </div>

EOT;
        }
     /**
         * @param string $tableName
         * @param array $fields
         * @return string
         */
        protected function _getShowAllViewContentBlock($tableName, $fields){
            $name = $this->_getStrViewDirOfController($tableName);
            $title = ucwords($this->_getStrViewDirOfName($tableName));
            $primaryKey = $this->_getPrimaryKey($fields);
            $params = array();
            foreach($primaryKey as $fieldKey){
                $pri = $fieldKey;
                $params[] = "$fieldKey=<?php echo \$this->$fieldKey; ?>";
            }
            $params = implode("&", $params);

            $viewFieldsTmp = array();
            $viewFirstFieldTmp = "";
            foreach($fields as $field){
                if($field['Field']=='IsInvisible')
                $viewFirstFieldTmp = "
                    <td width='20'><input type='checkbox' name='checkall' id='checkall' /></td>
                ";
                if($pri!=$field['Field'])
                $viewFieldsTmp[] = "<td>
                  <div class='column-sort'> 
                     <a class='sort-up' title='Sort up' href='<?php echo \$this->url(array('order'=>'{$field['Field']}', 'by'=>'ASC')); ?>' <?php echo (\$this->order == '{$field['Field']}' && \$this->by == 'ASC') ? 'active' : '';?>'></a>
                     <a class='sort-down' title='Sort down' href='<?php echo \$this->url(array('order'=>'{$field['Field']}', 'by'=>'DESC')); ?>' <?php echo (\$this->order == '{$field['Field']}' && \$this->by == 'DESC') ? 'active' : '';?>'></a>
                  </div>
                  {$field['Field']}
                </td>";
            }

            $viewFieldsTmp = implode("\n                ",$viewFieldsTmp);
            $actionAdd = '/' . $this->_getStrViewDirOfController($tableName).'/add';
            
            return <<<EOT
    <script type="text/javascript">
        $(document).ready(function(){
             $('#select-all').click(function () {
                $('.delete-checkbox').attr('checked', 'checked');
                return false;
             });
             $('#unselect-all').click(function () {
                 $('.delete-checkbox').attr('checked', '');
                 return false;
              });
        
            $(".butAdd").click(function(){
                window.location.href = "$actionAdd";
            });
            
            $(".butDelete").click(function(){
                if($("input#visible:checked").size() < 1){
                    alert('Please, select items');
                    return;
                }
                var inputs = $("input#visible");
                var data = {};
                inputs.each(function() {
                    if(this.checked){
                        data[this.name] = 1;
                    }else{
                        data[this.name] = 0;
                    }
                });
                $.post('/$name/ajax-update-visible', data, function(response) {
                    alert(response);
                    window.location.reload();
                });
            });
        
            $('#IsInvisible').change(function () {
                var url =  '<?php echo \$this->url(array('IsInvisible'=>'tmpValue')); ?>';
                var val = this.value;
                url = url.replace('tmpValue', val);
                window.location = url;
             });
            
            $('#$name-form').submit(function(){
                window.location.href = $(this).attr('action') + '/keyWord/' + encodeURI($('#keyWord').val()) + '/typeSearch/' + $('#typeSearch').val();
                return false;
            });
        });
   </script>
        
   <div class="content-table ">
      <div class="title-box">
        <div class="title-name">$title Manager</div>
        <div class="title-img"></div>
     </div>
     <?php echo \$this->renderBlock('search-$name', \$this); ?>
     <div class="block-controls">
          <?php echo \$this->paginationControl(
                     \$this->paginator,
                    'Sliding',
                    '_partials/pagination.phtml'
                    );
           ?>
     </div>
     <div class="table-border">
        <table width="100%" border="0" cellspacing="0" cellpadding="0">
            <thead>
                <tr class="title-tr">
                $viewFirstFieldTmp
                $viewFieldsTmp
                <td>Actions</td>
              </tr>
            </thead>
            <tbody>
                 <?php 
                     foreach(\$this->paginator as \$partial){
                         echo \$this->partial('_partials/$name/index.phtml', array('row'=>\$partial)
                     } 
                 ?>
            </tbody>
        </table>
     </div>
     <div class="pagination">
      <?php echo \$this->currentResultItemNumber(\$this->paginator);?>
    </div>
   </div>

EOT;

        }
        /**
         * @param string $tableName
         * @param array $fields
         * @return string
         */
        protected function _getShowAllViewContentPartial($tableName, $fields){
            $primaryKey = $this->_getPrimaryKey($fields);
            $params = array();
            foreach($primaryKey as $fieldKey){
                $pri = $fieldKey;
                $params[] = "$fieldKey=<?php echo \$this->row->$fieldKey; ?>";
            }
            $params = implode("&", $params);

            $viewFieldsTmp = array();
            $viewFirstFieldTmp = "";
            foreach($fields as $field){
                if($field['Field']=='IsInvisible')
                $viewFirstFieldTmp = "
                    <?php if(\$this->IsInvisible==0): ?>
                       <input type='checkbox' name='<?php echo \$this->row->$pri;?>' class='delete-checkbox'  id='visible' name='selected[]'>
                    <?php endif;?>
                ";
                if($pri!=$field['Field'] && $field['Field']!='IsInvisible')
                $viewFieldsTmp[].= "<td align='center'><?php echo \$this->row->{$field['Field']}; ?></td>";
                
                if($field['Field']=='IsInvisible')
                $viewFieldsTmp[] = "<td><?php echo (\$this->IsInvisible == 0) ? \"<div class='black-eye'></div>\" : \"<div class='gray-eye'></div>\"; ?></td>";
            }

            $viewFieldsTmp = implode("\n    ",$viewFieldsTmp);

            $actionUpdate = '/' . $this->_getStrViewDirOfController($tableName)
                    . '/update/'.$params;
            $actionDelete = '/' . $this->_getStrViewDirOfController($tableName)
                    . '/delete/'.$params;
            return <<<EOT
<tr class="bg-tr">
    $viewFirstFieldTmp
    $viewFieldsTmp
      
    <td width="5%">
        <a href="$actionUpdate" class="with-tip" title="Edit">
            <img src="images/icons/pencil.png">
        </a>
        <a href="$actionDelete" class="with-tip" title="Delete">
            <img src="images/icons/cross-circle.png">
        </a>
    </td>
</tr>

EOT;

        }
        /**
         * get content of Model DB TAble which name = $tableName
         *
         * @param string $tableName
         * @param array $cols: columns of table named $tableName
         * @return string
         */
        protected function _getBuildModelContent($tableName, $fields){
            $tableName = ucfirst($tableName);
            $className = self::BUILD_DIR_NAME . '_Model_DbTable_'. $tableName;

            $pri = $this->_getStrPrimaryKey($fields);

            $arrTmp[] = "<?php\n";
            $arrTmp[] = $this->_getStrDescriptionFile();
            $arrTmp[] = "class {$className} extends ". self::PARENT_MODEL_CLASS . "{ \n";
            $arrTmp[] = self::PADDING_DISTANCE .
                        "protected \$_name =  '{$tableName}';";
            $arrTmp[] = self::PADDING_DISTANCE .
                        "protected \$_primary  = {$pri};\n";

            $arrTmp[] = self::PADDING_DISTANCE .
                        "protected \$_dependentTables = array(";

            $arrTmp[] = $this->getStrDependentClasses($tableName);

            $arrTmp[] = self::PADDING_DISTANCE . "); \n";

            $arrTmp[] = self::PADDING_DISTANCE .
                        "protected \$_referenceMap = array(";

            $arrTmp[] = self::PADDING_DISTANCE .
                        $this->getStrReferenceMap($tableName);

            $arrTmp[] = self::PADDING_DISTANCE . "); \n";
            $arrTmp[] = "}";

            $content = implode("\n", $arrTmp);
            echo $content; die();
            return $content;
        }


        /**
         * @param string $tableName
         * @param array $fields
         * @return string
         */
        protected function _getBuildFormContent($tableName, $fields){
            $tableName = ucfirst($tableName);
            $className = self::BUILD_DIR_NAME . '_Form_'. $tableName;
            $arrTmp = array();
            $arrTmp[] = "<?php";
            $arrTmp[] = $this->_getStrDescriptionFile();
            $arrTmp[] = "class {$className} extends " . self::PARENT_FORM_CLASS . " { ";

            $arrTmp[] = self::PADDING_DISTANCE .
                        "protected \$_formType = 'Add';";

            $arrTmp[] = self::PADDING_DISTANCE .
                        "public function __construct(\$options = null) {";
            //construct function
            $arrTmp[] = self::PADDING_DISTANCE . self::PADDING_DISTANCE .
                        "parent::__construct(\$options);" .
                        "\n" .self::PADDING_DISTANCE . self::PADDING_DISTANCE .
                        '$this->setMethod("post");'.
                        "\n" .self::PADDING_DISTANCE . self::PADDING_DISTANCE .
                        '$this->setAttrib("class", "Vinaalo-Form");';

            $arrTmp[] = self::PADDING_DISTANCE . self::PADDING_DISTANCE .
                        "\$elements = array();";
//            echo 'dfdf'; die();
            foreach($fields as $field){
                $arrTmp[] = "\n" . $this->_getFormElementContent($field);
            }

            $arrTmp[] = "\n" . self::PADDING_DISTANCE . self::PADDING_DISTANCE .
                        '$this->addElements($elements);';

            $arrTmp[] = "\n" . self::PADDING_DISTANCE . self::PADDING_DISTANCE .
                        '$function = "set" . $this->_formType . "Form";' .
                        "\n" . self::PADDING_DISTANCE . self::PADDING_DISTANCE .
                        '$this->$function();';

            $arrTmp[] = self::PADDING_DISTANCE . "}";
            //set Add Funtion
            $arrTmp[] = "\n" . self::PADDING_DISTANCE .
                        'public function setAddForm(){' .
                        "\n" . self::PADDING_DISTANCE . self::PADDING_DISTANCE .
                        '$submit = new Zend_Form_Element_Submit("submit");' .
                        "\n" . self::PADDING_DISTANCE . self::PADDING_DISTANCE .
                        '$submit->setLabel("Add");' .
                        "\n" . self::PADDING_DISTANCE . self::PADDING_DISTANCE .
                        '$this->addElement($submit);';

            $arrTmp[] = self::PADDING_DISTANCE . "}";

            //set Update Funtion
            $arrTmp[] = "\n" . self::PADDING_DISTANCE .
                        'public function setUpdateForm(){' .
                        "\n" .self::PADDING_DISTANCE . self::PADDING_DISTANCE .
                        '$submit = new Zend_Form_Element_Submit("submit");' .
                        "\n" .self::PADDING_DISTANCE . self::PADDING_DISTANCE .
                        '$submit->setLabel("Update");' .
                        "\n" .self::PADDING_DISTANCE . self::PADDING_DISTANCE .
                        '$this->addElement($submit);';

            $arrTmp[] = self::PADDING_DISTANCE . "}";

            $arrTmp[] = "}";
            $content = implode("\n", $arrTmp);
//            echo $content; die();
            return $content;
        }
        /**
         * @return string
         */
        protected function _getContentTestController(){
            $tables = $this->_getColumnsOfAllTables();

            $namespace = $this->_getNamespace();
            $buildDirName = ucfirst(self::BUILD_DIR_NAME);
            $contentTmp = array();

            foreach($tables as $tableName => $fields){

                $primaryKey = $this->_getPrimaryKey($fields);

                /*
                 * set statement removeElement
                 */
                $strRemoveElements = array();
                $where = array();
                foreach($primaryKey as $fieldKey){
                    $strRemoveElements[] = "\$form->removeElement('$fieldKey');";
                }
                $strRemoveElements = implode("\n        ", $strRemoveElements);

                $action = 'show-all-' . $this->_getStrViewDirOfController($tableName);
                $contentTmp[] = <<<EOT

    public function add{$tableName}Action(){
        \$form = new {$buildDirName}_Form_{$tableName}();

        //$strRemoveElements
        if(\$this->_request->isPost()) {
            \$data = \$this->_request->getPost();
            if (\$form->isValid(\$data)) {
                \$this->_model->add{$tableName}(\$form->getValues());
                \$this->_helper->redirector('$action');
            }
        }

        \$this->view->form = \$form;

    }

    public function update{$tableName}Action(){
        \$form = new {$buildDirName}_Form_{$tableName}();

        if(\$this->_request->isPost()) {
            \$data = \$this->_request->getPost();
            if (\$form->isValid(\$data)) {
                \$this->_model->update{$tableName}(\$form->getValues());
                \$this->_helper->redirector('$action');
            }
        }
        \$primary = \$this->_request->getParam("primary");
        \$data = \$this->_model->fetchRow{$tableName}(\$primary)->toArray();
        \$form->getElement('submit')->setLabel('Update');
        \$form->populate(\$data);

        \$this->view->form = \$form;
    }

    public function showAll{$tableName}Action(){
        \$this->view->rows = \$this->_model->fetchAll{$tableName}();
    }
EOT;
            }

            $controllerClass = self::TEST_CONTROLLER_NAME . 'Controller';
            $modelClass = $namespace . '_Model_' . self::TEST_CONTROLLER_NAME;

            $contentTmp = implode("\n", $contentTmp);

            $content = <<<EOT
<?php
class {$controllerClass} extends Base_Controller_Action{
    protected \$_model;
    public function init(){
        \$this->_model = new {$modelClass}();
    }
    public function indexAction(){

    }
{$contentTmp}
}
EOT;

            return $content;
        }

        /**
         * @return string
         */
        protected function _getContentTestModel(){
            $tables = $this->_getColumnsOfAllTables();

            $namespace = self::BUILD_DIR_NAME;
            $contentTmp = array();

            foreach($tables as $tableName => $fields){
                $primaryKey = $this->_getPrimaryKey($fields);

                /*
                 * set statement unset and where
                 */
                $unset = array();
                $where = array();
                foreach($primaryKey as $fieldKey){
                    $unset[] = "unset(\$data['$fieldKey']);";
                    $where[] = "$fieldKey = {\$data['$fieldKey']}";
                }
                $unset = implode("\n        ", $unset);
                $where = implode(" AND ", $where);

                $contentTmp[] = <<<EOT
    public function add{$tableName}(\$data){
        unset(\$data['submit']);
        $unset
        \$model = new {$namespace}_Model_{$tableName}();
        try{
        \$model->insert(\$data);
        } catch (Exception \$e){
            echo \$e->getMessage();die;
        }
    }

    public function update{$tableName}(\$data){
        \$where = "$where";
        $unset
        unset(\$data['submit']);

        \$model = new {$namespace}_Model_{$tableName}();
        try{
            \$model->update(\$data, \$where);
        } catch (Exception \$e){
            echo \$e->getMessage();die;
        }
    }

    public function fetchAll{$tableName}(){

        \$model = new {$namespace}_Model_{$tableName}();
        return \$model->fetchAll();
    }

    public function fetchRow{$tableName}(\$primary){

        \$model = new {$namespace}_Model_{$tableName}();
        return \$model->find(\$primary)->current();
    }
EOT;
            }

            $modelClass = $this->_getNamespace() . '_Model_' . self::TEST_CONTROLLER_NAME;

            $contentTmp = implode("\n", $contentTmp);

            $content = <<<EOT
<?php
class {$modelClass} {

{$contentTmp}
}

EOT;

            return $content;
        }


        /**
         * @param string $tableName
         * @return string
         */
        protected function _getAddTestViewContent($tableName){
            return <<<EOT
<h1>Test Model And Form</h1>
<h3>Add $tableName</h3>
<?php echo \$this->form; ?>

EOT;
        }
        /**
         * @param string $tableName
         * @return string
         */
        protected function _getUpdateTestViewContent($tableName){
            return <<<EOT
<h1>Test Model And Form</h1>
<h3>Update $tableName</h3>
<?php echo \$this->form; ?>

EOT;
        }

        /**
         * @param string $tableName
         * @param array $fields
         * @return string
         */
        protected function _getShowAllTestViewContent($tableName, $fields){
            $primaryKey = $this->_getPrimaryKey($fields);
            $params = array();
            foreach($primaryKey as $fieldKey){
                $params[] = "primary[$fieldKey]=<?php echo \$row->$fieldKey; ?>";
            }
            $params = implode("&", $params);

            $viewFieldsTmp = array();
            foreach($fields as $field){
//                var_dump($field);die;
                $viewFieldsTmp[] = "<span><?php echo \$row->{$field['Field']}; ?></span>";
            }

            $viewFieldsTmp = implode(",\n        ",$viewFieldsTmp);

            $action = '/' . $this->_getStrViewDirOfController(self::TEST_CONTROLLER_NAME)
                    . '/update-'
                    . $this->_getStrViewDirOfController($tableName);
            return <<<EOT
<h1>Test Model And Form</h1>
<h3>Show all records of $tableName </h3>
<?php foreach (\$this->rows as \$row) :?>
    <div>
        $viewFieldsTmp
        --- <a href="$action?$params">Update</a>
    </div>
<?php endforeach; ?>

EOT;

        }
        /**
         * @param string $tableName
         * @return string
         */
        public function getStrDependentClasses($tableName){
            $strDependentClasses='';
            $dependentTables = $this->getDependentTables($tableName);
            foreach($dependentTables as $key => $table){
                $dependentTables[$key] = "        '" . $this->getDbTableClass($table) . "'";
            }

            $strDependentClasses = implode(",\n",$dependentTables);
//            Zend_Debug::dump($strDependentClasses);
            return $strDependentClasses;
        }

        /**
         * This function called from DbTable creating
         * @param string $tableName
         * @return string for $_referenceMaps variable
         */
        public function getStrReferenceMap($tableName){
            $strReferenceMap = '';

            $refTableNames = $this->getReferencedTableNames($tableName);

            foreach($refTableNames as $key => $referencedTable){
                $refTableNames[$key] = $this->getStrReferenceItem($tableName,$referencedTable);
            }
//            Zend_Debug::dump($refTableNames);
            $strReferenceMap = implode("\n", $refTableNames);

            return $strReferenceMap;
        }

        /**
         * @param string $tableName
         * @param string $referencedTableName
         * @return string
         */
        public function getStrReferenceItem($tableName, $referencedTableName){
            $foreignKeyCols  = $this->getForeignKeyInfos($tableName, $referencedTableName);
            $strResult = '';
            foreach($foreignKeyCols as $foreignKeyCol){
                $strResult  .= "\n";
                $strResult  .= "        '{$referencedTableName}.{$foreignKeyCol['COLUMN_NAME']}' => array(\n";
                $strResult  .= "            'columns'        => '" .
                                                $foreignKeyCol['COLUMN_NAME'] . "',\n";
                $strResult  .= "            'refTableClass'  => '" .
                                                $this->getDbTableClass($referencedTableName) . "',\n";
                $strResult  .= "            'refColumns'     => '" .
                                                $foreignKeyCol['REFERENCED_COLUMN_NAME'] . "',\n";
                $strResult  .= '        ),';
            }
            return $strResult;
        }

        /**
         * @desc return foreign key column and referenced column
         * @param string $tableName
         * @param string $referencedTableName
         * @return array:
         */
        public function getForeignKeyInfos($tableName, $referencedTableName){
            $this->_connectDb('information_schema');

            $sql = "SELECT KEY_COLUMN_USAGE.COLUMN_NAME,
                           KEY_COLUMN_USAGE.REFERENCED_COLUMN_NAME
                    FROM TABLE_CONSTRAINTS
                    INNER JOIN KEY_COLUMN_USAGE
                      ON TABLE_CONSTRAINTS.CONSTRAINT_NAME = KEY_COLUMN_USAGE.CONSTRAINT_NAME
                        AND TABLE_CONSTRAINTS.TABLE_SCHEMA = KEY_COLUMN_USAGE.CONSTRAINT_SCHEMA
                    WHERE TABLE_CONSTRAINTS.TABLE_SCHEMA = '$this->_dbName'
                      AND TABLE_CONSTRAINTS.CONSTRAINT_TYPE = 'FOREIGN KEY'
                      AND KEY_COLUMN_USAGE.TABLE_NAME = '$tableName'
                      AND KEY_COLUMN_USAGE.REFERENCED_TABLE_NAME = '$referencedTableName'";
//            var_dump($sql);die();
            $result = mysql_query($sql) or die("\$tablename=$tableName,REFERENCED_TABLE_NAME = $referencedTableName cannot query");

            $num_rows = mysql_num_rows($result);
            $foreignKeyCols = array();
            while (true ==($tmp = mysql_fetch_assoc($result))){
                $foreignKeyCols[] = $tmp;
            }

            return $foreignKeyCols;

        }

        /**
         * @param string $tableName
         * @return array: table referenced $tableName. So return array item is unique (Distinct)
         */
        public function getReferencedTableNames($tableName){
            $this->_connectDb('information_schema');

            $sql = "SELECT DISTINCT KEY_COLUMN_USAGE.REFERENCED_TABLE_NAME
                    FROM TABLE_CONSTRAINTS
                    INNER JOIN KEY_COLUMN_USAGE
                      ON TABLE_CONSTRAINTS.CONSTRAINT_NAME = KEY_COLUMN_USAGE.CONSTRAINT_NAME
                        AND TABLE_CONSTRAINTS.TABLE_SCHEMA = KEY_COLUMN_USAGE.CONSTRAINT_SCHEMA
                    WHERE TABLE_CONSTRAINTS.TABLE_SCHEMA = '$this->_dbName'
                      AND TABLE_CONSTRAINTS.CONSTRAINT_TYPE = 'FOREIGN KEY'
                      AND KEY_COLUMN_USAGE.TABLE_NAME = '$tableName'";

            $result = mysql_query($sql) or die("\$tablename=$tableName cannot query");

            $num_rows = mysql_num_rows($result);
            $refTables = array();
            while (true == ($tmp = mysql_fetch_assoc($result))){
                $refTables[] = $tmp['REFERENCED_TABLE_NAME'];
            }
//            Zend_Debug::dump($refTables); echo PHP_EOL . '<br>';


            return $refTables;
        }

        /**
         * This function called from getStrDependentClasses
         * @param string $tableName
         * @return multitype:
         */
        public function getDependentTables($tableName){
            $this->_connectDb('information_schema');

            $sql = "SELECT TABLE_CONSTRAINTS.TABLE_NAME
                    FROM TABLE_CONSTRAINTS
                    INNER JOIN REFERENTIAL_CONSTRAINTS
                      ON TABLE_CONSTRAINTS.CONSTRAINT_NAME = REFERENTIAL_CONSTRAINTS.CONSTRAINT_NAME
                        AND TABLE_CONSTRAINTS.CONSTRAINT_SCHEMA = REFERENTIAL_CONSTRAINTS.CONSTRAINT_SCHEMA
                    WHERE TABLE_CONSTRAINTS.TABLE_SCHEMA = '$this->_dbName'
                      AND TABLE_CONSTRAINTS.CONSTRAINT_TYPE = 'FOREIGN KEY'
                      AND REFERENTIAL_CONSTRAINTS.REFERENCED_TABLE_NAME = '$tableName'";

            $result = mysql_query($sql) or die('cannot query');

            $num_rows = mysql_num_rows($result);
            $tables = array();
            while (true==($tmp = mysql_fetch_assoc($result))){
                $tables[] = $tmp['TABLE_NAME'];
            }
//            Zend_Debug::dump($tables); echo PHP_EOL . '<br>';

            return $tables;
        }

        /**
         * @param string $tableName
         * @return string class name of dbtable class:
         * ex: Frontend_Model_DbTable_User;
         */
        public function getDbTableClass($tableName){
            $referenceClasses =
                    $this->_getNamespace() .
                    '_Model_DbTable_'.
                    ucfirst($tableName);

            return $referenceClasses;
        }

        /**
         * @desc:    create Model file
         */
        public function createModelFiles(){
            Color::output('================' . PHP_EOL , 'white');
            Color::output('Create Model Files', 'light_cyan');
            Color::output('================' . PHP_EOL , 'white');
            $dirPath = self::APPLICATION_DIR . '/models/DbTable';
            $this->_createDirStructure($dirPath);
            $tables = $this->_getColumnsOfAllTables();

            foreach ($tables as $tableName => $fields){
                //create file Model
                $content = $this->_getModelContent($tableName,$fields);
                $this->_createFile($dirPath, ucfirst($tableName) . '.php', $content);
            }
        }

        /**
         * @desc create form files.
         */
        public function createFormFiles(){
            Color::output('================' . PHP_EOL , 'white');
            Color::output('Create Form Files', 'light_cyan');
            Color::output('================' . PHP_EOL , 'white');

            // lay cac bang trong db
            $tables = $this->_getColumnsOfAllTables();
            $dirPath = self::APPLICATION_DIR . '/forms' ;
//            Zend_Debug::dump($tables);die();
            foreach ($tables as $tableName => $fields){

                //create dir for form
                $this->_createDirStructure($dirPath);

                $content = $this->_getFormContent($tableName,$fields);
//                var_dump($content);die();
                $this->_createFile($dirPath , ucfirst($tableName) .'.php', $content);
            }
        }

        /**
         * @desc create form files.
         */
        public function createControllerFiles(){
            Color::output('================' . PHP_EOL , 'white');
            Color::output('Create Controller Files', 'light_cyan');
            Color::output('================' . PHP_EOL , 'white');
            $dirPath = self::APPLICATION_DIR . '/controllers';
            //create dir for form
            $this->_createDirStructure($dirPath);

            // lay cac bang trong db
            $tables = $this->_getColumnsOfAllTables();
//            Zend_Debug::dump($tables);die();
            foreach ($tables as $tableName => $fields){

                $content = $this->_getControllerContent($tableName,$fields);
//                var_dump($content);die();
                $this->_createFile($dirPath, ucfirst($tableName) . 'Controller.php', $content);
            }
        }



        /**
         * @param array $tables
         */
        public function createViewFiles(){

            Color::output('================' , 'white');
            Color::output('Create View Files', 'light_cyan');
            Color::output('================' . PHP_EOL , 'white');

            $tables = $this->_getColumnsOfAllTables();
            /**
             * write test files
             */
            foreach($tables as $tableName => $fields){
                $viewDirTmp = $this->_getStrViewDirOfController($tableName);
                $dirPath = self::APPLICATION_DIR . '/views/scripts/' . $viewDirTmp;

                $addContentTmp = $this->_getAddViewContent($tableName);
                $addContentTmpBlock = $this->_getAddViewContentBlock($tableName);
                
                $updateContentTmp = $this->_getUpdateViewContent($tableName);
                $updateContentTmpBlock = $this->_getUpdateViewContentBlock($tableName);
                
                $showAllContentTmp = $this->_getShowAllViewContent($tableName,$fields);                
                $showAllContentTmpBlock = $this->_getShowAllViewContentBlock($tableName,$fields);
                
                $searchContentTmpBlock = $this->_getSearchViewContentBlock($tableName,$fields);
                
                $showAllContentTmpPartial = $this->_getShowAllViewContentPartial($tableName,$fields);
                
                $formContentTmpBlock = $this->_getFormViewContentBlock($tableName);
                
                
                $viewFileTmp = $this->_getStrViewDirOfController($tableName);

                //create dir for controller
//                die($showAllContentTmpBlock);
                /** create view file for controller add, update, show all*/
                if(!is_dir($dirPath)) mkdir($dirPath , 0777);
                    if(!file_exists($partial.'/add.phtml')) $this->_createFile($dirPath, 'add.phtml', $addContentTmpBlock);                        
                    if(!file_exists($partial.'/edit.phtml')) $this->_createFile($dirPath, 'edit.phtml', $updateContentTmpBlock);                        
                    if(!file_exists($partial.'/show-all.phtml')) $this->_createFile($dirPath, 'show-all.phtml', $showAllContentTmpBlock);
                    
                    if(!is_dir($dirPath.'/block')) mkdir($dirPath.'/block' , 0777);
                        //if(!file_exists($partial.'/block/add-'.$viewFileTmp.'.phtml')) $this->_createFile($dirPath.'/block', 'add-'.$viewFileTmp.'.phtml', $addContentTmpBlock);
                       // if(!file_exists($partial.'/block/update-'.$viewFileTmp.'.phtml')) $this->_createFile($dirPath.'/block', 'update-'.$viewFileTmp.'.phtml', $updateContentTmpBlock);
                        if(!file_exists($partial.'/block/form-'.$viewFileTmp.'.phtml')) $this->_createFile($dirPath.'/block', 'form-'.$viewFileTmp.'.phtml', $formContentTmpBlock);
                        //if(!file_exists($partial.'/block/show-all-'.$viewFileTmp.'.phtml')) $this->_createFile($dirPath.'/block', 'show-all-'.$viewFileTmp.'.phtml', $showAllContentTmp);
                        if(!file_exists($partial.'/block/search-'.$viewFileTmp.'.phtml')) $this->_createFile($dirPath.'/block', 'search-'.$viewFileTmp.'.phtml', $searchContentTmpBlock);
                        
                $partial = self::APPLICATION_DIR . '/views/scripts/_partials/'.$this->_getStrViewDirOfController($tableName);
                if(!is_dir($partial)) mkdir($partial , 0777);
                if(!file_exists($partial.'/index.phtml')) $this->_createFile($partial, 'index.phtml', $showAllContentTmpPartial);                
            }
        }

        /**
         * @param array $tables:
         */
        public function createTestControllerFiles(){
            $dirPath = self::APPLICATION_DIR . '/controllers';
            //create dir for controller
            $this->_createDirStructure($dirPath);

            $content = $this->_getContentTestController();

//          var_dump($content);die();
            $this->_createFile($dirPath, self::TEST_CONTROLLER_NAME . 'Controller.php', $content);
        }




        /**
         * @param array $tables
         */
        public function createTestViewFiles(){
            $viewDirTmp = $this->_getStrViewDirOfController(self::TEST_CONTROLLER_NAME);
            $dirPath = self::APPLICATION_DIR . '/views/scripts/' . $viewDirTmp;
            //create dir for controller
            $this->_createDirStructure($dirPath);
            $indexContent = array();
            $tables = $this->_getColumnsOfAllTables();
            /**
             * write test files
             */
            foreach($tables as $tableName => $fields){

                $addContentTmp = $this->_getAddTestViewContent($tableName);
                $updateContentTmp = $this->_getUpdateTestViewContent($tableName);
                $showAllContentTmp = $this->_getShowAllTestViewContent($tableName,$fields);

                $viewFileTmp = $this->_getStrViewDirOfController($tableName);

                /** create view file for controller add, update, show all*/
                $this->_createFile($dirPath, 'add-' . $viewFileTmp . '.phtml', $addContentTmp);
                $this->_createFile($dirPath, 'update-' . $viewFileTmp . '.phtml', $updateContentTmp);
                $this->_createFile($dirPath, 'show-all-' . $viewFileTmp . '.phtml', $showAllContentTmp);

                /** create links for file index */
                $addHrefTmp = "/$viewDirTmp/add-$viewFileTmp";
                $showAllHrefTmp = "/$viewDirTmp/show-all-$viewFileTmp";

                $indexContent[] = "<br/>{$tableName} \n<br/><a href='{$addHrefTmp}'>add</a>\n"
                                . "<a href='{$showAllHrefTmp}'>show all</a>\n";
            }

            /**
             * write file index.phtml
             * @var unknown_type
             */
            $contentTmp = implode("\n<br />", $indexContent);
            $this->_createFile($dirPath, 'index.phtml', $contentTmp);
        }
        /**
         * @param array $tables:
         */
        public function createTestModelFiles(){
            $dirPath = self::APPLICATION_DIR . '/models';
            //create dir for controller
            $this->_createDirStructure($dirPath);
            $content = $this->_getContentTestModel();
//          var_dump($content);die();
            $this->_createFile($dirPath, self::TEST_CONTROLLER_NAME . '.php', $content);
        }


        /**
         * @desc:    build Model file
         */
        public function buildModelFiles(){
            Color::output('================' , 'white');
            Color::output('Build Model File' , 'cyan');
            Color::output('================' . PHP_EOL , 'white');
            $dirPath = self::APPLICATION_DIR . '/../library/' . self::BUILD_DIR_NAME . '/Model';
            $this->_createDirStructure($dirPath);
            $tables = $this->_getColumnsOfAllTables();

            foreach ($tables as $tableName => $fields){
                //create file Model
                $content = $this->_getBuildModelContent($tableName,$fields);
                $this->_createFile($dirPath, ucfirst($tableName) . '.php', $content);
            }
        }

        /**
         * @desc create form files.
         */
        public function buildFormFiles(){
            Color::output('================' . PHP_EOL , 'white');
            Color::output('Build Form Form','cyan');
            Color::output('================' . PHP_EOL , 'white');
            $dirPath = self::APPLICATION_DIR  . '/../library/' . self::BUILD_DIR_NAME . '/Form';
            //create dir for form
            $this->_createDirStructure($dirPath);

            // lay cac bang trong db
            $tables = $this->_getColumnsOfAllTables();
//            Zend_Debug::dump($tables);die();
            foreach ($tables as $tableName => $fields){

                $content = $this->_getBuildFormContent($tableName,$fields);
//                var_dump($content);die();
                $this->_createFile($dirPath, ucfirst($tableName) . '.php', $content);
            }
        }

        /**
         * Create file of application
         */
        public function createAllFiles(){

            $this->createModelFiles();
            $this->createFormFiles();
            $this->createControllerFiles();
            $this->createViewFiles();
        }

        /**
         * create test file, include:
         *      controller  skeleton-test,
         *      model       SkeletonTest
         *      view        add, update, show-all for each form and model of Skeleton
         */
        public function createTestFiles(){
            Color::output('================', 'white');
            Color::output('Create Test Files', 'light_cyan');
            Color::output('================' . PHP_EOL , 'white');


//            Zend_Debug::dump($tables);die();
            $this->createTestControllerFiles();
            $this->createTestViewFiles();
            $this->createTestModelFiles();
        }
        /**
         * Build skeletion files for application,
         * These will be save in library directory
         */
        public function buildAllFiles(){

            $this->buildModelFiles();
            $this->buildFormFiles();
        }
    }

    /**
     * @desc    communicate command line
     *
     */
    class Vat{
        /**
         * @desc function analyze command line and generate object
         */
        public static function run(){
            //ex: 'create', 'build'
            $function = $_SERVER['argv'][1];
            //ex: 'model', 'form'
            $object = $_SERVER['argv'][2];

            $callFunction = strtolower($function) . ucfirst($object) .'Files';

            $generator = new Generator();

            $generator->$callFunction();


        }


    }

    /**
     * @desc output color string for command line
     *
     */
    class Color {
        private $foreground_colors = array();
        private $background_colors = array();

        public function __construct() {
            // Set up shell colors
            $this->foreground_colors['black'] = '0;30';
            $this->foreground_colors['dark_gray'] = '1;30';
            $this->foreground_colors['blue'] = '0;34';
            $this->foreground_colors['light_blue'] = '1;34';
            $this->foreground_colors['green'] = '0;32';
            $this->foreground_colors['light_green'] = '1;32';
            $this->foreground_colors['cyan'] = '0;36';
            $this->foreground_colors['light_cyan'] = '1;36';
            $this->foreground_colors['red'] = '0;31';
            $this->foreground_colors['light_red'] = '1;31';
            $this->foreground_colors['purple'] = '0;35';
            $this->foreground_colors['light_purple'] = '1;35';
            $this->foreground_colors['brown'] = '0;33';
            $this->foreground_colors['yellow'] = '1;33';
            $this->foreground_colors['light_gray'] = '0;37';
            $this->foreground_colors['white'] = '1;37';

            $this->background_colors['black'] = '40';
            $this->background_colors['red'] = '41';
            $this->background_colors['green'] = '42';
            $this->background_colors['yellow'] = '43';
            $this->background_colors['blue'] = '44';
            $this->background_colors['magenta'] = '45';
            $this->background_colors['cyan'] = '46';
            $this->background_colors['light_gray'] = '47';
        }

        // Returns colored string
        public function getStringLine($string, $foreground_color = null) {
            $colored_string = "";

            // Check if given foreground color found
            if (isset($this->foreground_colors[$foreground_color])) {
                $colored_string .= "\033[" . $this->foreground_colors[$foreground_color] . "m";
            }
            // Check if given background color found
//            if (isset($this->background_colors[$background_color])) {
//                $colored_string .= "\033[" . $this->background_colors[$background_color] . "m";
//            }

            // Add string and end coloring
            $colored_string .=  $string . "\033[0m";

            return $colored_string;

        }

        // Returns all foreground color names
        public function getForegroundColors() {
            return array_keys($this->foreground_colors);
        }

        // Returns all background color names
        public function getBackgroundColors() {
            return array_keys($this->background_colors);
        }

        /**
         * function output color string on command line
         */
        public static function output($string, $foreground_color = null){
            $color = new self();
            echo PHP_EOL . $color->getStringLine($string, $foreground_color);
        }
    }

    /**
     * run application
     */
    Color::output('Vina Alo Tool is running' . PHP_EOL,'blue');
    Vat::run();
    Color::output('================Completed================' . PHP_EOL,'blue');