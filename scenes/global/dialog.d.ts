

declare module 'dialog.json' {
    export default DialogFileObject
}

interface DialogFileObject {
    profiles: Profiles,
    dialog: {
        [key: string]: {
            [key: string]: {
                sequence: Array<DialogFrame>
            }
        }
    }
}

interface Profiles {
    [key: string]: string
}


type DialogFrame = (DialogDefaultFrame | DialogOptionFrame | DialogConditionFrame)

interface DialogDefaultFrame {
    profile?: keyof Profiles,
    vars?: Array<string>,
    text: string,
    next: number
}

interface DialogOptionFrame {
    profile?: keyof Profiles,
    vars?: Array<string>,
    text?: string,
    option: Array<DialogFrame>
}

interface DialogConditionFrame {
    cond: [...(DialogFrame & Expression)[], DialogFrame]
}

interface Expression {
    expr?: "string"
}